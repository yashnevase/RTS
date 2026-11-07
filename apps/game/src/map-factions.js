import {Sprite,Texture} from 'pixi.js';
import {project,unproject,mapSize} from '../../../packages/map/src/index.ts';
import {cell,terrain} from '../../../packages/sim/src/navigation.ts';
import {records,hubs} from './places.js';

export const factions={
  polity_adil_shahi:{name:'Adil Shahi',color:'#198566',mark:'◇'},
  polity_nizam_shahi:{name:'Nizam Shahi',color:'#bd741c',mark:'✦'},
  polity_portuguese:{name:'Portuguese',color:'#b43f4e',mark:'✚'},
  polity_mughal:{name:'Mughal',color:'#415ea9',mark:'☾'}
};
export const affiliation=record=>record.ownership?.controller_polity_id??record.ownership?.sovereign_polity_id;

export function createFactionOverlay(){
  const canvas=document.createElement('canvas');
  canvas.width=Math.ceil(mapSize.width);
  canvas.height=Math.ceil(mapSize.height);
  const ctx=canvas.getContext('2d');
  const step=5;
  const cols=Math.ceil(canvas.width/step),rows=Math.ceil(canvas.height/step);
  const centres=records.filter(record=>hubs.includes(record.id)||record.kind==='fort').map(record=>({...project(record.coordinate),faction:affiliation(record)}));
  const tiles=Array.from({length:rows},()=>Array(cols).fill(null));
  for(let y=0;y<rows;y++)for(let x=0;x<cols;x++){
    const mx=(x+.5)*step,my=(y+.5)*step;
    const ground=cell(unproject(mx,my));
    if(!terrain.cost[ground])continue;
    let nearest=null,range=88**2;
    for(const point of centres){
      const distance=(point.x-mx)**2+(point.y-my)**2;
      if(distance<range){nearest=point;range=distance;}
    }
    if(nearest&&factions[nearest.faction])tiles[y][x]=nearest.faction;
  }
  for(let y=0;y<rows;y++)for(let x=0;x<cols;x++){
    const id=tiles[y][x];
    if(!id)continue;
    ctx.fillStyle=factions[id].color+'55';
    ctx.fillRect(x*step,y*step,step,step);
    ctx.strokeStyle=factions[id].color;
    ctx.lineWidth=1.3;
    for(const [dx,dy] of [[0,-1],[-1,0],[1,0],[0,1]]){
      if(tiles[y+dy]?.[x+dx]===id)continue;
      const left=(x+Math.max(dx,0))*step,top=(y+Math.max(dy,0))*step;
      ctx.beginPath();ctx.moveTo(left,top);
      ctx.lineTo(left+(dy?step:0),top+(dx?step:0));ctx.stroke();
    }
  }
  return new Sprite(Texture.from(canvas));
}
