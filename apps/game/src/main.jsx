import React, { useEffect, useRef, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { Application, Sprite, Assets, Graphics, Text } from 'pixi.js';
import { byId, records, hubs, districts, districtOf, visibleIds } from './places.js';
import { project, mapSize } from '../../../packages/map/src/index.ts';
import { homeCamera, zoomAt, reserveLabel } from '../../../packages/map/src/camera.ts';
import './style.css';

function MapView({ selected, onSelect, visible, hub, register }) {
  const host = useRef(null);
  const controls = useRef(null);
  const latest = useRef({selected, onSelect, visible, hub, register});
  latest.current = {selected, onSelect, visible, hub, register};
  const [error, setError] = useState('');
  useEffect(() => {
    let disposed = false;
    const app = new Application();
    const element = host.current;
    let cleanup = () => {};
    (async () => {
      await app.init({resizeTo:element, background:'#172822', antialias:true, autoDensity:true, resolution:Math.min(devicePixelRatio,2), preference:'webgl'});
      if (disposed) { app.destroy(true); return; }
      element.appendChild(app.canvas);
      const [texture, fortArt, townArt] = await Promise.all(['/terrain/maharashtra-goa.webp','/art/fort-token.webp','/art/village-token.webp'].map(path => Assets.load(path)));
      if (disposed) return;
      const terrain = new Sprite(texture);
      const marks = new Graphics();
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
      app.stage.addChildAt(terrain,0);
      app.stage.addChildAt(marks,1);
      let camera = homeCamera(element.clientWidth, element.clientHeight);
      let drag = null;
      let moved = false;
      let previousSelection = null;
      let previousFrame = null;
      function home() { camera = homeCamera(element.clientWidth,element.clientHeight); }
      function zoom(factor, x=element.clientWidth/2, y=element.clientHeight/2) {
        camera = zoomAt(camera,x,y,factor,homeCamera(element.clientWidth,element.clientHeight).zoom);
      }
      controls.current = {home,zoom};
      function draw() {
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
        const signature = [camera.x,camera.y,camera.zoom,element.clientWidth,element.clientHeight,active?.id,district,all,shown.size,[...shown][0]].join('|');
        if (signature === previousFrame) return;
        previousFrame = signature;
        terrain.position.set(camera.x,camera.y);
        terrain.width = mapSize.width*camera.zoom;
        terrain.height = mapSize.height*camera.zoom;
        marks.clear();
        const placed = [];
        if (!all) {
          for (const [fort, satellites] of Object.entries(districts[district] ?? {})) {
            for (const [start,end] of [[district,fort], ...satellites.map(id => [fort,id])]) {
              const a = project(byId.get(start).coordinate), b = project(byId.get(end).coordinate);
              marks.moveTo(camera.x+a.x*camera.zoom,camera.y+a.y*camera.zoom)
                .lineTo(camera.x+b.x*camera.zoom,camera.y+b.y*camera.zoom).stroke({color:0x735129,alpha:.7,width:1.5});
            }
          }
        }
        const priority = record => record.id === active?.id ? 3 : hubs.includes(record.id) ? 2 : record.kind === 'fort' ? 1 : 0;
        const order = records.map((record,i)=>({record,i})).sort((a,b)=>priority(b.record)-priority(a.record));
        for (const {record,i} of order) {
          const point = project(record.coordinate);
          const x=camera.x+point.x*camera.zoom, y=camera.y+point.y*camera.zoom;
          const visible = shown.has(record.id);
          tokens[i].visible = visible;
          labels[i].visible=false;
          if (!visible) continue;
          const icon = tokens[i];
          const width = all ? 16 : hubs.includes(record.id) ? 62 : record.kind === 'fort' ? 44 : 28;
          icon.position.set(x,y); icon.width=width; icon.height=width*icon.texture.height/icon.texture.width;
          const heraldry = {polity_adil_shahi:0x375849, polity_nizam_shahi:0x81562a, polity_portuguese:0x824852, polity_mughal:0x454d72};
          const sovereign = record.ownership?.sovereign_polity_id;
          if (hubs.includes(record.id) && heraldry[sovereign]) {
            const pole = x + width * .29, top = y - icon.height - 10;
            marks.moveTo(pole,y-3).lineTo(pole,top).stroke({color:0x4d391d,width:1});
            marks.poly([pole,top,pole+12,top+1,pole+8,top+4,pole+12,top+7,pole,top+7]).fill(heraldry[sovereign]).stroke({color:0xe5cea0,width:.8});
          }
          if(record.id===active?.id) marks.ellipse(x,y+1,width*.5,5).stroke({color:0xffe29b,width:2});
          const label=labels[i];
          const rect={x:x-label.width/2,y:y+4,width:label.width+5,height:label.height+3};
          if(reserveLabel(rect,placed,element.clientWidth,element.clientHeight)) {
            label.position.set(rect.x,rect.y); label.visible=true;
          }
        }
      }
      app.ticker.add(draw);
      function down(event) { element.setPointerCapture(event.pointerId); drag={x:event.clientX,y:event.clientY}; moved=false; }
      function move(event) {
        if(!drag) return;
        const dx=event.clientX-drag.x,dy=event.clientY-drag.y;
        if(Math.abs(dx)+Math.abs(dy)>2) moved=true;
        camera.x+=dx; camera.y+=dy; drag={x:event.clientX,y:event.clientY};
      }
      function up(event) {
        if(!drag) return;
        drag=null;
        if(moved) return;
        const bounds=element.getBoundingClientRect();
        const x=event.clientX-bounds.left,y=event.clientY-bounds.top;
        const nearby=records.filter(r=>latest.current.visible.has(r.id)).map(record=>{
          const token=tokens[records.indexOf(record)];
          const dx=Math.max(0,Math.abs(x-token.x)-token.width/2);
          const dy=Math.max(0,token.y-token.height-y,y-token.y);
          return {record,distance:Math.hypot(dx,dy)};
        }).filter(r=>r.distance<16).sort((a,b)=>a.distance-b.distance);
        if(nearby.length) latest.current.onSelect(nearby[0].record);
      }
      function wheel(event) {
        event.preventDefault(); const bounds=element.getBoundingClientRect();
        zoom(Math.exp(-event.deltaY*.001),event.clientX-bounds.left,event.clientY-bounds.top);
      }
      element.addEventListener('pointerdown',down); element.addEventListener('pointermove',move);
      element.addEventListener('pointerup',up); element.addEventListener('wheel',wheel,{passive:false});
      cleanup=()=>{
        element.removeEventListener('pointerdown',down);element.removeEventListener('pointermove',move);
        element.removeEventListener('pointerup',up);element.removeEventListener('wheel',wheel);
      };
    })().catch(e=>{if(!disposed)setError(e.message);});
    return ()=>{disposed=true;cleanup();controls.current=null;if(app.renderer)app.destroy(true);};
  },[]);
  return <section className="map"><div className="viewport" ref={host}/><div className="tools">
    <button onClick={()=>controls.current?.zoom(1.4)} aria-label="Zoom in">+</button>
    <button onClick={()=>controls.current?.zoom(1/1.4)} aria-label="Zoom out">−</button>
    <button onClick={()=>controls.current?.home()}>Fit region</button>
  </div><div className="compass" aria-hidden="true">N<br/>✥</div>
  <div className="legend">{register?'Historical register':'Campaign districts'} <small>Drag to pan · Scroll to zoom</small></div>
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
  const [selected,setSelected]=useState(byId.get('site_pune'));
  const [hub,setHub]=useState('site_pune');
  const [register,setRegister]=useState(false);
  const [query,setQuery]=useState('');
  const [kind,setKind]=useState('all');
  const visible = visibleIds(hub,register);
  if (register && kind!=='all') for (const id of visible) if(byId.get(id).kind!==kind) visible.delete(id);
  function select(record) {
    setSelected({...record});
    setHub(districtOf(record.id) ?? hub);
  }
  function changeMode(value) {
    setRegister(value);setKind('all');setQuery('');
    if(!value) select(byId.get(hub));
  }
  const results=records.filter(r => visible.has(r.id) && (register || hubs.includes(r.id)) &&
    (r.name+' '+r.id).toLowerCase().includes(query.trim().toLowerCase()));
  return <main><header><div className="brand"><h1>Deccan Warlords</h1></div><div className="edition">Campaign atlas<span>Maharashtra &amp; Goa · 1622</span></div></header>
    <div className="layout"><MapView selected={selected} onSelect={select} visible={visible} hub={hub} register={register}/>
    <aside><div className="chapter"><div className="eyebrow">Western Deccan</div><h2>{register?'Historical register':'Settlement districts'}</h2></div>
    <nav><button aria-pressed={!register} onClick={()=>changeMode(false)}>Campaign</button><button aria-pressed={register} onClick={()=>changeMode(true)}>Register</button></nav>
    {register?<><input aria-label="Find a place" placeholder="Find a name or ID…" value={query} onChange={e=>setQuery(e.target.value)}/>
      <div className="filters">{['all','site','fort'].map(k=><button key={k} aria-pressed={kind===k} onClick={()=>setKind(k)}>{k==='all'?'All':k==='site'?'Settlements':'Forts'}</button>)}</div>
      <ul>{results.map(r=><li key={r.id}><button onClick={()=>select(r)}>{r.name}</button></li>)}</ul></>:
      <><label className="selectLabel">Market or coastal seat<select value={hub} onChange={e=>select(byId.get(e.target.value))}>{hubs.map(id=><option value={id} key={id}>{byId.get(id).name}</option>)}</select></label>
      <div className="district"><button className="seat" onClick={()=>select(byId.get(hub))}>{byId.get(hub).name}</button>
      {Object.entries(districts[hub]).map(([fort,places])=><div className="branch" key={fort}><button onClick={()=>select(byId.get(fort))}>⚑ {byId.get(fort).name}</button>
      {places.map(id=><button className="satellite" key={id} onClick={()=>select(byId.get(id))}>↳ {byId.get(id).name}</button>)}</div>)}</div></>}
    <article aria-live="polite"><div className="portrait"><img src="/art/envoy.webp" alt="Illustrated fictional campaign envoy"/><div><small>Field journal</small><h2>{selected.name}</h2></div></div>
    <div className="entry"><div className="eyebrow">{(selected.site_type||selected.fort_type).replaceAll('_',' ')}</div><Authority record={selected}/>
    <details key={selected.id}><summary>Historical notes</summary><p>{selected.notes}</p><small>{selected.confidence || 'Reference'} · {selected.status} · {selected.coordinate.latitude.toFixed(3)}° N, {selected.coordinate.longitude.toFixed(3)}° E</small>{selected.source&&<a href={selected.source}> UNESCO record</a>}</details></div></article>
    <details className="court"><summary>Courts &amp; coastal powers</summary><div className="powerList">{[
      ['Nizam Shahi','site_pune','#81562a'],['Bijapur','site_solapur','#375849'],
      ['Mughal frontier','landmark_burhanpur','#454d72'],['Portuguese Goa','landmark_old_goa','#824852'],
      ['Siddi command · Janjira','fort_janjira','#777063']
    ].map(([label,id,color])=><button key={id} onClick={()=>{setRegister(false);select(byId.get(id));}}><i style={{backgroundColor:color}}/>{label}</button>)}</div>
    <p>Standards indicate recorded sovereign claims. Janjira’s suzerainty is disputed.</p></details>
    </aside></div></main>;
}
createRoot(document.getElementById('root')).render(<Atlas/>);
