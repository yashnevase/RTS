import { Sprite, Texture } from 'pixi.js';
import { project, mapSize } from '../../../packages/map/src/index.ts';
import { coordinate, denseForest, terrain } from '../../../packages/sim/src/navigation.ts';

export function createMapGeography() {
  const resolution = 2.4;
  const canvas = document.createElement('canvas');
  canvas.width = Math.ceil(mapSize.width*resolution);
  canvas.height = Math.ceil(mapSize.height*resolution);
  const ctx = canvas.getContext('2d');
  ctx.scale(resolution,resolution);

  function line(points,style,width) {
    const [first,...rest]=points.map(project);
    ctx.beginPath();
    ctx.moveTo(first.x,first.y);
    for (const point of rest) ctx.lineTo(point.x,point.y);
    ctx.strokeStyle=style;
    ctx.lineWidth=width;
    ctx.stroke();
  }

  const groves=terrain.woodland.map(id=>({id,...project(coordinate(id))}));
  for (const {x,y} of groves) {
    const shade=ctx.createRadialGradient(x,y,0,x,y,5.7);
    shade.addColorStop(0,'#50603567');
    shade.addColorStop(1,'#50603500');
    ctx.fillStyle=shade;
    ctx.fillRect(x-6,y-6,12,12);
  }

  const greens=['#697b46','#7b8850','#52643e','#5f7248'];
  for (const {id,x,y} of groves) {
    for(let tree=0;tree<2+id%3;tree++){
      const tx=x+((id*13+tree*31)%17-8)*.32;
      const ty=y+((id*19+tree*43)%13-6)*.36;
      const size=.5+((id+tree*17)%7)*.095;
      ctx.beginPath();
      ctx.ellipse(tx+size*.65,ty+size*.45,size*1.45,size*.62,.15,0,Math.PI*2);
      ctx.fillStyle='#35422d57';
      ctx.fill();
      ctx.beginPath();
      ctx.ellipse(tx,ty,size*.83,size*1.13,-.17,0,Math.PI*2);
      ctx.fillStyle=greens[(id+tree)%greens.length];
      ctx.fill();
      ctx.beginPath();
      ctx.ellipse(tx-size*.16,ty-size*.33,size*.42,size*.54,0,0,Math.PI*2);
      ctx.fillStyle='#b5af684d';
      ctx.fill();
    }
  }

  for(const id of denseForest){
    const {x,y}=project(coordinate(id));
    const canopy=ctx.createRadialGradient(x,y,0,x,y,5.8);
    canopy.addColorStop(0,'#182d19dc');
    canopy.addColorStop(1,'#21392300');
    ctx.fillStyle=canopy;
    ctx.fillRect(x-6,y-6,12,12);
    for(let crown=0;crown<5;crown++){
      ctx.beginPath();
      ctx.arc(x+((id+crown*7)%11-5)*.58,y+((id+crown*5)%9-4)*.58,.8+(crown%3)*.25,0,Math.PI*2);
      ctx.fillStyle=crown%2?'#314f2c':'#648250';
      ctx.fill();
    }
  }

  ctx.lineJoin=ctx.lineCap='round';
  for(const river of terrain.rivers) {
    if(river.length<2) continue;
    const points=river.map(([longitude,latitude])=>({longitude,latitude}));
    line(points,'#677d4b29',4.9);
    line(points,'#686b4e60',1.45);
    line(points,'#47787ec2',1.35);
    line(points,'#91b3a851',.31);
  }
  return new Sprite(Texture.from(canvas));
}
