import grid from './navigation.json' with {type:'json'};
export interface Point {latitude:number;longitude:number}
export const terrain = grid;
export function cell(p:Point) {
 const x=Math.floor((p.longitude-grid.west)/(grid.east-grid.west)*grid.width);
 const y=Math.floor((grid.north-p.latitude)/(grid.north-grid.south)*grid.height);
 return x<0||x>=grid.width||y<0||y>=grid.height?-1:y*grid.width+x;
}
export function coordinate(id:number):Point {
 return {longitude:grid.west+(id%grid.width+.5)/grid.width*(grid.east-grid.west),
 latitude:grid.north-(Math.floor(id/grid.width)+.5)/grid.height*(grid.north-grid.south)};
}
export function anchor(id:string):Point {return (grid.anchors as Record<string,Point>)[id];}
export function accessible(p:Point) {
 const id=cell(p);return id>=0 && grid.cost[id]>0;
}
function nearest(p:Point) {
 const origin=cell(p);if(origin<0)return -1;
 for(let radius=0;radius<5;radius++)for(let dy=-radius;dy<=radius;dy++)for(let dx=-radius;dx<=radius;dx++){
 const x=origin%grid.width+dx,y=Math.floor(origin/grid.width)+dy;
 if(x>=0&&x<grid.width&&y>=0&&y<grid.height&&grid.cost[y*grid.width+x])return y*grid.width+x;
 }return -1;
}
export function route(start:Point,end:Point,snap=false):Point[]|null {
 const a=nearest(start),b=snap?nearest(end):cell(end);
 if(a<0||b<0||!grid.cost[b])return null;
 const costs=new Map<number,number>([[a,0]]),parents=new Map<number,number>();
 const open=new Set([a]),closed=new Set<number>();
 const heuristic=(id:number)=>{
   const dx=Math.abs(id%grid.width-b%grid.width),dy=Math.abs(Math.floor(id/grid.width)-Math.floor(b/grid.width));
   return 10*(dx+dy)-6*Math.min(dx,dy);
 };
 while(open.size){
 let current=-1,best=Infinity;
 for(const id of open){const f=costs.get(id)!+heuristic(id)*10;if(f<best){best=f;current=id;}}
 if(current===b){const path=[b];while(path[0]!==a)path.unshift(parents.get(path[0])!);return smooth([start,...path.map(coordinate),end]);}
 open.delete(current);closed.add(current);
 for(const [dx,dy] of [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]){
 const x=current%grid.width+dx,y=Math.floor(current/grid.width)+dy,id=y*grid.width+x;
 if(x<0||x>=grid.width||y<0||y>=grid.height||!grid.cost[id]||closed.has(id))continue;
 if(dx&&dy&&(!grid.cost[Math.floor(current/grid.width)*grid.width+x]||!grid.cost[y*grid.width+current%grid.width]))continue;
 const cost=costs.get(current)!+Math.round(grid.cost[id]*(dx&&dy?1.4142:1));
 if(cost<(costs.get(id)??Infinity)){costs.set(id,cost);parents.set(id,current);open.add(id);}
 }
 }return null;
}
export function metres(a:Point,b:Point) {
 return Math.round(Math.hypot((a.longitude-b.longitude)*105000,(a.latitude-b.latitude)*111000));
}


// Sample at subcell intervals and reject diagonal passage between touching obstacles.
export function clearSegment(a:Point,b:Point) {
 const dx=(b.longitude-a.longitude)*grid.width/(grid.east-grid.west);
 const dy=(b.latitude-a.latitude)*grid.height/(grid.north-grid.south);
 const steps=Math.max(1,Math.ceil(Math.max(Math.abs(dx),Math.abs(dy))*8));
 let previous=cell(a);
 if(!accessible(a))return false;
 for(let i=1;i<=steps;i++){
   const point={longitude:a.longitude+(b.longitude-a.longitude)*i/steps,latitude:a.latitude+(b.latitude-a.latitude)*i/steps};
   const next=cell(point);
   if(next<0||!grid.cost[next])return false;
   const px=previous%grid.width,py=Math.floor(previous/grid.width),nx=next%grid.width,ny=Math.floor(next/grid.width);
   if(px!==nx&&py!==ny&&(!grid.cost[py*grid.width+nx]||!grid.cost[ny*grid.width+px]))return false;
   previous=next;
 }return true;
}
function smooth(points:Point[]) {
 if(points.length<3)return points;
 const result=[points[0]];
 let index=0;
 while(index<points.length-1){
   let next=index+1;
   for(let candidate=points.length-1;candidate>index+1;candidate--){
     if(clearSegment(points[index],points[candidate])){next=candidate;break;}
   }
   result.push(points[next]);index=next;
 }return result;
}
