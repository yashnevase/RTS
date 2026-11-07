import {campaignWeather} from '../../../packages/sim/src/weather.ts';
import {separateMarker} from '../../../packages/map/src/marker-layout.ts';
import { affiliation, createFactionOverlay, factions } from './map-factions.js';
import { TradeScreen } from './TradeScreen.jsx';
import { anchor, coordinate, metres, route, terrain as navigationTerrain } from '../../../packages/sim/src/navigation.ts';
import React, { useEffect, useRef, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { Application, Sprite, Assets, Graphics, Text } from 'pixi.js';
import { byId, records, hubs, districts, districtOf, visibleIds } from './places.js';
import { CampaignPlayback, sampleTrail } from '../../../packages/map/src/party-animation.ts';
import { project, unproject, mapSize } from '../../../packages/map/src/index.ts';
import { homeCamera, zoomAt, reserveLabel } from '../../../packages/map/src/camera.ts';
import { locationOf, useCampaign } from './Campaign.jsx';
import { Screens } from './Screens.jsx';
import { Creation, Clock } from './Hud.jsx';
import { campaignHourMs } from './campaign-clock.js';
import { createMapGeography } from './map-geography.js';
import './style.css';

function MapView({ selected, onSelect, visible, hub, register, world, inspect, onInspect, locate, onOrder, onDeselect, follow, onPan, snapshots, onArrival }) {
  const host = useRef(null);
  const controls = useRef(null);
  const latest = useRef(null);
  latest.current = {selected, onSelect, visible, hub, register, world, inspect, onInspect, locate, onOrder, onDeselect, follow, onPan, onArrival};
  const [error, setError] = useState('');
  const [showCrossings,setShowCrossings]=useState(false);
  const [showFactions,setShowFactions]=useState(true);
  const factionMode=useRef(true);
  factionMode.current=showFactions;
  const crossingMode=useRef(false);
  crossingMode.current=showCrossings;
  useEffect(() => {
    let disposed = false;
    const app = new Application();
    const element = host.current;
    let cleanup = () => {};
    (async () => {
      await app.init({
        resizeTo:element,background:'#172822',autoDensity:true,resolution:Math.min(devicePixelRatio,2),
        preference:'webgl',powerPreference:'high-performance'
      });
      if (disposed) { app.destroy(true); return; }
      element.appendChild(app.canvas);
      const [texture, fortArt, townArt, portraitTexture, caravanArt, villageArt] = await Promise.all([
        '/terrain/maharashtra-goa.webp','/art/fort-token.webp','/art/village-token.webp',
        '/art/campaign-rider.webp','/art/campaign-caravan.webp','/art/campaign-villagers.webp'
      ].map(path => Assets.load(path)));
      if (disposed) return;
      const terrain = new Sprite(texture);
      const geography = createMapGeography();
      const influence=createFactionOverlay();
      const crossingMarks = new Graphics();
      const corridors=[['site_chaul','site_pune'],['site_pune','site_ahmadnagar'],['site_pune','site_saswad'],['site_saswad','fort_purandar'],['site_pune','fort_kondhana']]
        .map(([from,to])=>route(anchor(from),anchor(to))??[]);
      const crossingPoints=navigationTerrain.crossings.map(id=>project(coordinate(id)));
      const marks = new Graphics();
      const plaques = new Graphics();
      const tokens = records.map(record => {
        const token = new Sprite(record.kind === 'fort' ? fortArt : townArt);
        token.anchor.set(.5,.95);
        app.stage.addChild(token);
        return token;
      });
      const labels = records.map(record => {
        const label = new Text({text:record.name, style:{fontFamily:'Georgia', fontSize:15, fontWeight:'600', fill:'#302719', stroke:{color:'#efdbaf',width:3}}});
        app.stage.addChild(label);
        return label;
      });
      const labelPlaques = new Set();
      app.stage.addChildAt(terrain,0);

      app.stage.addChildAt(geography,2);
      app.stage.addChildAt(marks,3);
      app.stage.addChildAt(crossingMarks,4);
      app.stage.addChildAt(plaques,5+tokens.length);
      app.stage.addChildAt(influence,3);
      const badges=records.map(record=>{
        const badge=new Text({text:factions[affiliation(record)]?.mark??'·',style:{fontFamily:'Georgia',fontSize:11,fill:'#fff6cf',stroke:{color:'#281e15',width:1}}});
        badge.anchor.set(.5);
        app.stage.addChild(badge);
        return badge;
      });
      let camera = homeCamera(element.clientWidth, element.clientHeight);
      let drag = null;
      let moved = false;
      let hovered=null;
      const cameraKeys=new Set();
      let previousSelection = null;
      let previousFrame = null;
      let lastLocate = null;
      let destinationPulse = null;
      const positions=latest.current.world.parties.map(party=>{
        const {x,y}=project(locationOf(party));
        return {drawX:x,drawY:y,facing:1,turn:1,heading:0,phase:0,gait:0};
      });
      let playback = new CampaignPlayback(campaignHourMs);
      let lastSnapshot = latest.current.world;
      function finish(frame) {
        frame.trails.forEach((trail,i)=>{
          const point=trail.at(-1);
          positions[i].drawX=point.x;
          positions[i].drawY=point.y;
        });
        if (frame.arrival === lastSnapshot.parties[0].node && !lastSnapshot.parties[0].motion) {
          latest.current.onArrival(frame.arrival);
        }
      }
      function receive(next) {
        const previous = lastSnapshot;
        if(next.parties.map(p=>p.id).join()!==previous.parties.map(p=>p.id).join()){
          playback=new CampaignPlayback(campaignHourMs);
          positions.length=0;
          for(const portrait of portraits){app.stage.removeChild(portrait);portrait.destroy();}
          portraits.length=0;
          for(const banner of banners){app.stage.removeChild(banner);banner.destroy();}
          banners.length=0;
          for(const party of next.parties){
            const point=project(locationOf(party));
            positions.push({drawX:point.x,drawY:point.y,facing:1,turn:1,heading:0,phase:0,gait:0});
            banners.push(createPartyDisplay(party));
          }
          lastSnapshot=next;
          return;
        }
        lastSnapshot = next;
        const advanced = next.tick > previous.tick;
        const reset = next.started !== previous.started || next.tick < previous.tick ||
          (!advanced && next.parties.some((party,i)=>{
            const before=locationOf(previous.parties[i]), after=locationOf(party);
            return before.longitude!==after.longitude || before.latitude!==after.latitude;
          }));
        const frame = {
          trails: next.parties.map(party=>advanced && party.trail?.length ? party.trail.map(project) : [project(locationOf(party))]),
          arrival: advanced && previous.parties[0].motion && !next.parties[0].motion ? next.parties[0].node : null
        };
        if (reset || document.hidden || advanced && !previous.speed && !next.speed) {
          playback = new CampaignPlayback(campaignHourMs);
          finish({...frame,arrival:reset ? null : frame.arrival});
        } else if (advanced) {
          playback.enqueue(frame);
        }
      }
      const portraits = [];
      const cloth = new Graphics();
      app.stage.addChild(cloth);
      const partyColors = {villagers:'#93814f',caravan:'#3f7769',patrol:'#7d5640'};
      snapshots.current.add(receive);
      const banners = latest.current.world.parties.map(createPartyDisplay);
      function createPartyDisplay(party) {
        const label = new Text({text:({caravan:'◆ ',villagers:'✿ ',patrol:'⚔ '}[party.id]??'')+party.name, style:{
          fontFamily:'Georgia',fontWeight:'bold',fontSize:13,fill:'#f8e4b8'}});
        app.stage.addChild(label);
        const portrait=new Sprite({caravan:caravanArt,villagers:villageArt}[party.id]??portraitTexture);
        portrait.label='party:'+party.id;
        portrait.anchor.set(.5,1);
        app.stage.addChild(portrait);portraits.push(portrait);
        return label;
      }
      function home() {
        latest.current.onPan();
        camera = homeCamera(element.clientWidth,element.clientHeight);
      }
      function zoom(factor, x=element.clientWidth/2, y=element.clientHeight/2) {
        camera = zoomAt(camera,x,y,factor,homeCamera(element.clientWidth,element.clientHeight).zoom);
      }
      controls.current = {home,zoom};
      function draw(ticker) {
        const {selected:active, visible:shown, hub:district, register:all} = latest.current;
        if (active !== previousSelection) {
          previousSelection = active;
          if (active) {
            const point = project(active.coordinate);
            camera.zoom = Math.max(camera.zoom,active.id === 'landmark_old_goa' ? 1.5 : Math.min(4, Math.max(1.6, element.clientWidth/310)));
            camera.x = element.clientWidth/2-point.x*camera.zoom;
            camera.y = element.clientHeight/2-point.y*camera.zoom;
          }
        }
        const {world, locate, inspect} = latest.current;
        if (locate && locate !== lastLocate) {
          lastLocate = locate;
          const point = positions[world.parties.findIndex(p=>p.id===locate.id)];
          camera.x=element.clientWidth/2-point.drawX*camera.zoom;
          camera.y=element.clientHeight/2-point.drawY*camera.zoom;
        }
        const now=performance.now();
        const speed=lastSnapshot.speed;
        for (const frame of playback.advance(ticker.deltaMS,speed)) finish(frame);
        playback.hour?.trails.forEach((trail,i)=>{
          const display=positions[i],pose=sampleTrail(trail,playback.progress);
          display.drawX=pose.x;
          display.drawY=pose.y;
          if(trail.length>1){
            display.heading=pose.heading;
            const horizontal=Math.cos(pose.heading);
            if(Math.abs(horizontal)>.22) display.facing=horizontal<0?-1:1;
          }
        });
        if(cameraKeys.size){
          const dt=ticker.deltaMS*.52;
          camera.x+=dt*(Number(cameraKeys.has('a'))-Number(cameraKeys.has('d')));
          camera.y+=dt*(Number(cameraKeys.has('w'))-Number(cameraKeys.has('s')));
        }
        if (latest.current.follow && !(drag&&moved) && !cameraKeys.size) {
          const player=positions[0];
          camera.x=element.clientWidth/2-player.drawX*camera.zoom;
          camera.y=element.clientHeight/2-player.drawY*camera.zoom;
        }
        const partyBoxes=[];
        cloth.clear();
        if(destinationPulse){
          const age=(now-destinationPulse.at)/500;
          if(age>=1) destinationPulse=null;
          else {
            const {x,y}=destinationPulse;
            cloth.ellipse(camera.x+x*camera.zoom,camera.y+y*camera.zoom,5+age*18,3+age*9)
              .stroke({color:0xffd282,width:2,alpha:1-age});
          }
        }
        for(const [i,party] of world.parties.entries()){
          const label=banners[i], rider=portraits[i], display=positions[i];
          const moving=playback.hour?.trails[i].length>1;
          const x=camera.x+display.drawX*camera.zoom,y=camera.y+display.drawY*camera.zoom;
          label.visible=rider.visible=!all&&x>-65&&y>-65&&x<element.clientWidth+65&&y<element.clientHeight+65;
          if(!rider.visible) continue;
          if (speed) {
            display.gait += ((moving?1:0)-display.gait)*Math.min(1,ticker.deltaMS/100);
            display.turn += (display.facing-display.turn)*Math.min(1,ticker.deltaMS/52);
            if (moving) display.phase += ticker.deltaMS*(speed>1?.021:.014);
          }
          const bob=-Math.abs(Math.sin(display.phase))*2.6*display.gait;
          const size=Math.max(24,Math.min(53,23+camera.zoom*5.5))*(party.id==='caravan'?.68:party.id==='villagers'?.79:1);
          rider.height=size;
          rider.width=size*rider.texture.width/rider.texture.height;
          rider.position.set(x,y+bob);
          const perspective=.72+.28*Math.abs(Math.cos(display.heading));
          rider.scale.x=Math.abs(rider.scale.x)*(display.turn<0?-1:1)*(.56+.44*Math.abs(display.turn))*perspective;
          rider.rotation=(Math.sin(display.phase)*.062+Math.sin(display.heading)*.045)*display.gait;
          cloth.ellipse(x,y,rider.width*.36,size*.09).fill({color:0x342718,alpha:.34});
          if(party.id===inspect)cloth.ellipse(x,y,size*.38,size*.13).stroke({color:0xffd282,width:1.5,alpha:.9});
          if(moving && display.gait>.3) {
            const step=(Math.sin(display.phase-1)+1)/2;
            const distance=9+step*11;
            cloth.ellipse(x-Math.cos(display.heading)*distance,y-Math.sin(display.heading)*distance,3+step*6,2+step)
              .fill({color:0xd8b87a,alpha:(1-step)*.32});
          }
          const wave=Math.sin(now/215+i)*2.7,pole=x+size*.23,top=y-size-5+bob;
          const color=i===0||party.id.startsWith('clan:')?(world.identity?.color??'#b74338'):(partyColors[party.id]??'#58765c');
          cloth.moveTo(pole,y-4).lineTo(pole,top).stroke({color:0x3b2918,width:1.5});
          cloth.poly([pole,top,pole+18,top+1+wave,pole+14,top+7+wave,pole+18,top+13+wave,pole,top+12])
            .fill(color).stroke({color:0xe3c582,width:1});
          if(i===0){
            const identity=world.identity;
            const emblem=identity?.symbol==='Crescent'?'☾':identity?.symbol==='Diamond'?'◆':'☀';
            label.text=emblem+' '+(identity?.name??'Your company')+' · '+(1+(world.encounter?.guards??3));
          }
          label.position.set(x+12,y+7);
          while(partyBoxes.some(box=>Math.abs(label.x-box.x)<Math.max(box.width,label.width)&&Math.abs(label.y-box.y)<20))label.y-=21;
          partyBoxes.push({x:label.x,y:label.y,width:label.width});
          label.alpha=party.id===inspect||i===0?1:.85;
          cloth.roundRect(label.x-5,label.y-2,label.width+10,label.height+4,3)
            .fill({color:0x292316,alpha:.9}).stroke({color,width:1.2});
        }
        const signature = [camera.x,camera.y,camera.zoom,element.clientWidth,element.clientHeight,active?.id,hovered,district,all,factionMode.current,crossingMode.current,[...shown].join()].join('|');
        if (signature === previousFrame) return;
        previousFrame = signature;
        terrain.position.set(camera.x,camera.y);
        terrain.width = mapSize.width*camera.zoom;
        terrain.height = mapSize.height*camera.zoom;
        geography.position.copyFrom(terrain.position);
        geography.width=terrain.width;
        geography.height=terrain.height;
        influence.position.copyFrom(terrain.position);
        influence.width=terrain.width;influence.height=terrain.height;
        influence.visible=factionMode.current;
        influence.alpha=camera.zoom<=2?1:.47;
        marks.clear();
        plaques.clear();
        crossingMarks.clear();
        if(crossingMode.current)for(const corridor of corridors){
          if(corridor.length<2)continue;
          const points=corridor.map(project);
          crossingMarks.moveTo(camera.x+points[0].x*camera.zoom,camera.y+points[0].y*camera.zoom);
          for(const point of points.slice(1))crossingMarks.lineTo(camera.x+point.x*camera.zoom,camera.y+point.y*camera.zoom);
          crossingMarks.stroke({color:0xffd495,width:3,alpha:.9});
        }
        if(crossingMode.current)for(const point of crossingPoints){
          const x=camera.x+point.x*camera.zoom,y=camera.y+point.y*camera.zoom;
          if(x<0||x>element.clientWidth||y<0||y>element.clientHeight)continue;
          crossingMarks.roundRect(x-4,y-2.5,8,5,1).fill('#e4ce9f').stroke({color:'#254d58',width:1.4});
        }
        const placed = [];
        const markerBoxes=[];
        const priority = record => record.id === active?.id ? 3 : hubs.includes(record.id) ? 2 : record.kind === 'fort' ? 1 : 0;
        const order = records.map((record,i)=>({record,i})).sort((a,b)=>priority(b.record)-priority(a.record));
        for (const {record,i} of order) {
          const point = project(record.coordinate);
          let x=camera.x+point.x*camera.zoom, y=camera.y+point.y*camera.zoom;
          const visible = shown.has(record.id)&&x>-90&&x<element.clientWidth+90&&y>-50&&y<element.clientHeight+90;
          tokens[i].visible = visible;
          labels[i].visible=false;
          badges[i].visible=false;
          if (!visible) continue;
          const icon = tokens[i];
          const width = all ? 24 : (hubs.includes(record.id) ? 104 : record.kind === 'fort' ? 76 : 52)*Math.min(1,.4+camera.zoom*.2);
          const desired={x,y,width,height:width*icon.texture.height/icon.texture.width};
          const separated=separateMarker(desired,markerBoxes);markerBoxes.push(separated);
          if(separated.x!==x||separated.y!==y)marks.moveTo(x,y).lineTo(separated.x,separated.y).stroke({color:0x80623d,width:1,alpha:.6});
          x=separated.x;y=separated.y;
          icon.position.set(x,y); icon.width=width; icon.height=desired.height;
          const faction=factions[affiliation(record)];
          if (hubs.includes(record.id) || record.kind === 'fort') {
            const flag=faction?.color??0x777067;
            marks.ellipse(x,y+2,width*.56,9).fill({color:flag,alpha:.55})
              .stroke({color:flag,width:2});
            const pole = x + width * .29, top = y - icon.height - 10;
            marks.moveTo(pole,y-3).lineTo(pole,top).stroke({color:0x4d391d,width:1});
            marks.poly([pole,top,pole+22,top+1,pole+18,top+7,pole+22,top+13,pole,top+13]).fill(flag).stroke({color:0xe5cea0,width:.9});
            badges[i].position.set(pole+9,top+6.5);
            badges[i].visible=true;
          }
          const highlighted=record.id===active?.id||record.id===hovered;
          marks.ellipse(x,y+1,width*.57,Math.max(7,width*.13)).stroke({color:highlighted?0xffe29b:0x67462b,width:highlighted?3:1.5,alpha:highlighted?1:.85});
          const label=labels[i];
          const hasPlaque=!all&&hubs.includes(record.id);
          if(hasPlaque!==labelPlaques.has(i)){
            label.style.fill=hasPlaque?'#f8e7be':'#302719';
            label.style.stroke=hasPlaque?{color:'#33291b',width:1}:{color:'#efdbaf',width:3};
            if(hasPlaque)labelPlaques.add(i);
            else labelPlaques.delete(i);
          }
          const rect={x:x-label.width/2,y:y+4,width:label.width+5,height:label.height+3};
          if(reserveLabel(rect,placed,element.clientWidth,element.clientHeight)) {
            label.position.set(rect.x,rect.y); label.visible=true;
            if(hasPlaque){
              plaques.roundRect(rect.x-8,rect.y-3,rect.width+11,rect.height+3,3)
                .fill({color:0x33291b,alpha:.88}).stroke({color:faction?.color??0x8b754e,width:1.5});
            }
          }
        }
      }
      app.ticker.add(draw);
      function down(event) {
        if(event.button!==0) return;
        element.setPointerCapture(event.pointerId);
        drag={x:event.clientX,y:event.clientY};
        moved=false;
      }
      function move(event) {
        if(!drag) return;
        const dx=event.clientX-drag.x,dy=event.clientY-drag.y;
        if(!moved){
          if(Math.hypot(dx,dy)<5) return;
          moved=true;
          latest.current.onPan();
        }
        camera.x+=dx; camera.y+=dy; drag={x:event.clientX,y:event.clientY};
      }
      function targetAt(x,y){
        const places=records.flatMap((record,i)=>{
          const token=tokens[i],label=labels[i];
          if(!token.visible)return [];
          if(label.visible&&x>=label.x-5&&x<=label.x+label.width+5&&y>=label.y-2&&y<=label.y+label.height+3)
            return [{record,distance:0}];
          const dx=Math.max(0,Math.abs(x-token.x)-token.width*.52);
          const dy=Math.max(0,token.y-token.height-y,y-token.y-9);
          return [{record,distance:Math.hypot(dx,dy)}];
        }).filter(r=>r.distance<22).sort((a,b)=>a.distance-b.distance);
        if(!latest.current.register&&!places.some(place=>place.distance===0)){
          const party=banners.findIndex((flag,index)=>{
            if(index===0||!flag.visible)return false;
            const rider=portraits[index];
            const inLabel=x>=flag.x-8&&x<=flag.x+flag.width+8&&y>=flag.y-8&&y<=flag.y+flag.height+8;
            const inSprite=Math.abs(x-rider.x)<=rider.width/2+15&&y>=rider.y-rider.height-12&&y<=rider.y+13;
            return inLabel||inSprite;
          });
          if(party>=0)return {party:latest.current.world.parties[party].id};
        }
        return places[0]??{};
      }
      function pointerPosition(event){
        const bounds=element.getBoundingClientRect();
        return [event.clientX-bounds.left,event.clientY-bounds.top];
      }
      function hover(event){
        if(drag)return;
        const {record,party}=targetAt(...pointerPosition(event));
        hovered=record?.id??null;
        element.style.cursor=record||party?'pointer':'crosshair';
        element.title=record?.name??(party?latest.current.world.parties.find(p=>p.id===party)?.name:'');
      }
      function hit(event) {
        const [x,y]=pointerPosition(event);
        const {record,party}=targetAt(x,y);
        if(party){latest.current.onInspect(party);return;}
        if(record) {
          if(latest.current.register) latest.current.onSelect(record);
          else {
            const player=lastSnapshot.parties[0];
            const point=project(locationOf(player));
            const atRest=Math.hypot(positions[0].drawX-point.x,positions[0].drawY-point.y)<.01;
            if(player.node===record.id&&!player.motion&&atRest) latest.current.onArrival(record.id);
            else {
              destinationPulse={...project(record.coordinate),at:performance.now()};
              latest.current.onOrder(record);
            }
          }
        }
        else if(!latest.current.register) {
          const mapX=(x-camera.x)/camera.zoom,mapY=(y-camera.y)/camera.zoom;
          destinationPulse={x:mapX,y:mapY,at:performance.now()};
          latest.current.onOrder({coordinate:unproject(mapX,mapY)});
        }
      }
      function up(event) {
        if(!drag) return;
        drag=null;
        if(!moved) hit(event);
      }
      function right(event) { event.preventDefault();latest.current.onDeselect(); }
      function cancel() { drag=null; }
      function keyDown(event){
        const key=event.key.toLowerCase();
        if(!'wasd'.includes(key)||key.length!==1||!latest.current.world.started||event.altKey||event.ctrlKey||event.metaKey||
           event.target.closest('input,select,textarea,[role=dialog]')||document.querySelector('[aria-modal=true]'))return;
        event.preventDefault();
        if(!cameraKeys.size)latest.current.onPan();
        cameraKeys.add(key);
      }
      function keyUp(event){cameraKeys.delete(event.key.toLowerCase());}
      function clearKeys(){cameraKeys.clear();}
      window.addEventListener('keydown',keyDown);
      window.addEventListener('keyup',keyUp);
      window.addEventListener('blur',clearKeys);
      element.addEventListener('pointermove',hover);
      element.addEventListener('contextmenu',right);
      element.addEventListener('pointercancel',cancel);
      function wheel(event) {
        event.preventDefault(); const bounds=element.getBoundingClientRect();
        zoom(Math.exp(-event.deltaY*.001),event.clientX-bounds.left,event.clientY-bounds.top);
      }
      element.addEventListener('pointerdown',down); element.addEventListener('pointermove',move);
      element.addEventListener('pointerup',up); element.addEventListener('wheel',wheel,{passive:false});
      cleanup=()=>{
        snapshots.current.delete(receive);
        window.removeEventListener('keydown',keyDown);
        window.removeEventListener('keyup',keyUp);
        window.removeEventListener('blur',clearKeys);
        element.removeEventListener('pointermove',hover);
        element.removeEventListener('contextmenu',right);element.removeEventListener('pointercancel',cancel);
        element.removeEventListener('pointerdown',down);element.removeEventListener('pointermove',move);
        element.removeEventListener('pointerup',up);element.removeEventListener('wheel',wheel);
      };
    })().catch(e=>{if(!disposed)setError(e.message);});
    return ()=>{disposed=true;cleanup();controls.current=null;if(app.renderer)app.destroy(true);};
  },[]);
  const weather=campaignWeather(world.tick,world.parties[0].point?.longitude??74);
  return <section className="map"><div className="viewport" ref={host}/><div className={'map-weather'+(weather.night?' night':'')+(weather.rain?' rain':'')+(weather.fog?' fog':'')} aria-hidden="true"/><div className="weather-label">{weather.label} · Travel {weather.movementPercent}%</div><div className="tools">
    <button onClick={()=>controls.current?.zoom(1.4)} aria-label="Zoom in">+</button>
    <button onClick={()=>controls.current?.zoom(1/1.4)} aria-label="Zoom out">−</button>
    <button onClick={()=>controls.current?.home()}>Fit region</button>
    <button aria-pressed={showFactions} onClick={()=>setShowFactions(!showFactions)}>Factions</button>
    <button aria-pressed={showCrossings} title="Show provisional river crossing points" onClick={()=>setShowCrossings(!showCrossings)}>Crossings</button>
    <button onClick={()=>{if(document.fullscreenElement) document.exitFullscreen(); else document.querySelector('main')?.requestFullscreen?.();}}>Full screen</button>
  </div><div className="compass" aria-hidden="true">N<br/>✥</div>
  <div className="legend">{register?'Historical register':'Campaign districts'} <small>Drag to pan · WASD pans · Scroll zooms · Left-click to travel · Right-click to deselect</small>{showCrossings&&<small>Gold tracks and bridge symbols show provisional routes. Dark forest cores block travel.</small>}{showFactions&&<small className="faction-key">Approximate influence {Object.values(factions).map(faction=><span key={faction.name}><i style={{background:faction.color}}>{faction.mark}</i> {faction.name}</span>)}</small>}</div>
  <a className="credit" href="https://github.com/tilezen/joerd/blob/master/docs/attribution.md" target="_blank" rel="noreferrer">Terrain · Mapzen / USGS / NOAA</a>
  {error&&<p className="error">Map could not load. {error}</p>}</section>;
}

const powers = {
  polity_nizam_shahi:'Nizam Shahi', polity_adil_shahi:'Bijapur · Adil Shahi',
  polity_portuguese:'Portuguese', polity_mughal:'Mughal'
};
function Authority({record}) {
  const name = id => powers[id] ?? (id ? id.replace(/^polity_/, '').replaceAll('_',' ') : 'Unknown');
  return <dl><dt>Sovereignty</dt><dd>{name(record.ownership?.sovereign_polity_id)}</dd>
    <dt>Control</dt><dd>{name(record.ownership?.controller_polity_id)}</dd></dl>;
}

function Atlas() {
  const {world,send,snapshots}=useCampaign();
  const [follow,setFollow]=useState(false);
  const [arrival,setArrival]=useState(null);
  const [dismissal,setDismissal]=useState(0);
  const [inspect,setInspect]=useState('player');
  const [meeting,setMeeting]=useState(null);
  const [locate,setLocate]=useState(null);
  const [openPlace,setOpenPlace]=useState(null);
  const [selected,setSelected]=useState(byId.get('site_pune'));
  const [hub,setHub]=useState('site_pune');
  const [register,setRegister]=useState(false);
  const [query,setQuery]=useState('');
  const [kind,setKind]=useState('all');
  const inspectedParty=world.parties.find(party=>party.id===inspect&&party.id!=='player');
  const inReach=inspectedParty&&metres(locationOf(world.parties[0]),locationOf(inspectedParty))<=4000;
  function inspectParty(id){
    setMeeting(null);setInspect(id);
    if(id&&id!=='player')send({type:'approach-party',party:id});
  }
  useEffect(()=>{
    if(!world.partyMeeting)return;
    setInspect(world.partyMeeting.party);setMeeting('talk');
  },[world.partyMeeting?.party,world.partyMeeting?.tick]);
  useEffect(()=>{
    if(!meeting)return;
    const close=event=>{if(event.key==='Escape'){setMeeting(null);setInspect(null);}};
    window.addEventListener('keydown',close);
    return ()=>window.removeEventListener('keydown',close);
  },[meeting]);
  const visible = visibleIds(hub,register);
  if (!register) visible.add('site_khirki');
  if (register && kind!=='all') for (const id of visible) if(byId.get(id).kind!==kind) visible.delete(id);
  function select(record) {
    setFollow(false);
    setSelected({...record});
    setHub(districtOf(record.id) ?? hub);
  }
  function changeMode(value) {
    setFollow(false);
    setRegister(value);setKind('all');setQuery('');
    if(!value) select(byId.get(hub));
  }
  const results=records.filter(r => visible.has(r.id) && (register || hubs.includes(r.id)) &&
    (r.name+' '+r.id).toLowerCase().includes(query.trim().toLowerCase()));
  return <main className="campaign-shell"><MapView selected={selected} onSelect={record=>{select(record);setOpenPlace(record);}} visible={visible} hub={hub} register={register} world={world} snapshots={snapshots} inspect={inspect} onInspect={inspectParty} locate={locate} follow={follow} onPan={()=>setFollow(false)} onArrival={id=>setArrival({id})} onDeselect={()=>{setOpenPlace(null);inspectParty(null);setSelected(null);setDismissal(value=>value+1);}} onOrder={record=>{
    setOpenPlace(null);
    setSelected(null);
    send(record.id?{type:'travel',to:record.id}:{type:'move',point:record.coordinate});
  }}/>
  <div className="map-title"><span>DECCAN WARLORDS</span><small>Maharashtra &amp; Goa · 1622</small></div>
  {inspectedParty&&<div className="party-card"><button className="close" aria-label="Deselect party" onClick={()=>inspectParty(null)}>×</button><strong>{inspectedParty.name}</strong>
    <small>{inspectedParty.motion?.destination?'Travelling to '+(byId.get(inspectedParty.motion.destination)?.name??'open country'):'At '+(byId.get(inspectedParty.node)?.name??'open country')}</small>
    <button onClick={()=>{setFollow(false);setLocate({id:inspectedParty.id});}}>Center</button>
    <button disabled={!inReach} onClick={()=>{send({type:'speed',value:0});setMeeting('talk');}}>Talk</button>
    {inspectedParty.id==='caravan'&&<button disabled={!inReach} onClick={()=>{send({type:'speed',value:0});setMeeting('trade');}}>Trade</button>}
    {!inReach&&<small>Approach within 4 km to speak.</small>}
    </div>}
  {meeting==='talk'&&inspectedParty&&<div className="screen-shade">
    <section className="roadside-scene" role="dialog" aria-label={'Talk to '+inspectedParty.name}>
      <img className="roadside-character" src={inspectedParty.id==='villagers'?'/art/saswad-supplier.webp':inspectedParty.id==='patrol'?'/art/foot-guard.webp':'/art/campaign-caravan.webp'} alt=""/>
      <div className="roadside-dialogue">
        <h2>{inspectedParty.name}</h2>
        <p>{inspectedParty.id==='caravan'?'We carry grain and wood when the markets have stock.':inspectedParty.id==='villagers'?'We are travelling between villages and markets.':'We patrol the hill approaches. Keep to the clear ground.'}</p>
        {inspectedParty.id==='caravan'&&<button disabled={!inReach} onClick={()=>setMeeting('trade')}>Show me your goods</button>}
        <button onClick={()=>inspectParty(null)}>Leave</button>
      </div>
    </section>
  </div>}
  {meeting==='trade'&&inspectedParty?.id==='caravan'&&<div className="screen-shade"><section className="game-screen" role="dialog" aria-label="Caravan trade"><TradeScreen world={world} site="caravan" local={inReach} send={send} onClose={()=>setMeeting(null)}/></section></div>}
  <Clock world={world} send={send} follow={follow} setFollow={setFollow} onLocate={()=>setLocate({id:'player'})}/>
  <button className="places-toggle" onClick={()=>setRegister(!register)}>{register?'Close places':'Places'}</button>
  {register&&<div className="places-drawer"><input aria-label="Find a place" value={query} onChange={e=>setQuery(e.target.value)} placeholder="Find a place…"/><ul>{results.map(r=><li key={r.id}><button onClick={()=>{select(r);setOpenPlace(r);setRegister(false);}}>{r.name}</button></li>)}</ul></div>}
  {openPlace&&<div className="place-card"><button className="close" onClick={()=>setOpenPlace(null)}>×</button><p className="eyebrow">{openPlace.site_type||openPlace.fort_type}</p><h2>{openPlace.name}</h2><Authority record={openPlace}/><button onClick={()=>{send({type:'travel',to:openPlace.id});setOpenPlace(null);}}>Travel here</button><details><summary>Journal</summary><p>{openPlace.notes}</p></details></div>}
  <details className="world-events"><summary>World events{world.events?.length?' · '+world.events.length:''}</summary><ol>{world.events?.map(event=><li key={event.id}><time>Day {1+Math.floor((event.tick+6)/24)}</time> {event.text}</li>)}</ol></details>
  <Screens world={world} send={send} arrival={arrival} dismissal={dismissal} onLocate={record=>{setRegister(false);if(record.partyId){setLocate({id:record.partyId});setSelected(null);}else{select(record);setOpenPlace(record);}}}/>
  {world.started===false&&<Creation send={send}/>}
  </main>;
}
createRoot(document.getElementById('root')).render(<Atlas/>);
