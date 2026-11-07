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
export function anchor(id:string):Point|undefined {
 const point=(grid.anchors as Partial<Record<string,Point>>)[id];
 if(!point || accessible(point))return point;
 const entry=nearest(point);
 return entry<0?undefined:coordinate(entry);
}
export function accessible(p:Point) {
 const id=cell(p);return id>=0 && grid.cost[id]>0;
}
function nearest(p:Point) {
 const origin=cell(p);if(origin<0)return -1;
 if(grid.cost[origin])return origin;
 let best=-1,distance=Infinity;
 for(let dy=-4;dy<=4;dy++)for(let dx=-4;dx<=4;dx++){
 const x=origin%grid.width+dx,y=Math.floor(origin/grid.width)+dy;
 const id=y*grid.width+x;
 if(x<0||x>=grid.width||y<0||y>=grid.height||!grid.cost[id])continue;
 const gap=metres(p,coordinate(id));
 if(gap<distance){best=id;distance=gap;}
 }return best;
}
export function route(start:Point,end:Point,snap=false):Point[]|null {
 const a=nearest(start),b=snap?nearest(end):cell(end);
 if(a<0||b<0||!grid.cost[b])return null;
 const entry=accessible(start)?start:coordinate(a);
 const exit=accessible(end)?end:coordinate(b);
 if(metres(entry,exit)===0)return [exit];
 const costs=new Map<number,number>([[a,0]]),parents=new Map<number,number>();
 const open=new Set([a]),closed=new Set<number>();
 const heuristic=(id:number)=>{
   const dx=Math.abs(id%grid.width-b%grid.width),dy=Math.abs(Math.floor(id/grid.width)-Math.floor(b/grid.width));
   return 10*(dx+dy)-6*Math.min(dx,dy);
 };
 while(open.size){
 let current=-1,best=Infinity;
 for(const id of open){const f=costs.get(id)!+heuristic(id)*10;if(f<best){best=f;current=id;}}
 if(current===b){const path=[b];while(path[0]!==a)path.unshift(parents.get(path[0])!);return roundBends(smooth([entry,...path.map(coordinate),exit]));}
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

export function travelEffort(a:Point,b:Point) {
 const length=metres(a,b),steps=Math.max(1,Math.ceil(length/1000));
 let total=0;
 for(let i=0;i<steps;i++){
   const t=(i+.5)/steps,id=cell({longitude:a.longitude+(b.longitude-a.longitude)*t,latitude:a.latitude+(b.latitude-a.latitude)*t});
   total+=terrain.cost[id]||10;
 }
 return Math.round(length*total/steps/10);
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
 const cost=[0];
 for(let i=1;i<points.length;i++)cost.push(cost[i-1]+travelEffort(points[i-1],points[i]));
 const result=[points[0]];
 let index=0;
 while(index<points.length-1){
   let next=index+1;
   for(let candidate=points.length-1;candidate>index+1;candidate--){
     if(clearSegment(points[index],points[candidate]) &&
       travelEffort(points[index],points[candidate])<=cost[candidate]-cost[index]){
       next=candidate;break;
     }
   }
   result.push(points[next]);index=next;
 }return result;
}

function between(a:Point,b:Point,t:number):Point {
 return {longitude:a.longitude+(b.longitude-a.longitude)*t,latitude:a.latitude+(b.latitude-a.latitude)*t};
}

// Round turns within the traversable corridor. Keep sharp turns where the
// curve would cross an obstacle, such as the bank of a river crossing.
function roundBends(points:Point[]) {
 if(points.length<3)return points;
 const result=[points[0]];
 for(let i=1;i<points.length-1;i++){
   const corner=points[i],before=points[i-1],after=points[i+1];
   const entry=between(corner,before,Math.min(.24,1800/Math.max(1,metres(corner,before))));
   const exit=between(corner,after,Math.min(.24,1800/Math.max(1,metres(corner,after))));
   const curve=[entry,...[1/3,2/3].map(t=>between(between(entry,corner,t),between(corner,exit,t),t)),exit];
   const curveCost=curve.slice(1).reduce((sum,point,index)=>sum+travelEffort(curve[index],point),0);
   if(curveCost<=travelEffort(entry,corner)+travelEffort(corner,exit) &&
      curve.slice(1).every((point,index)=>clearSegment(curve[index],point)))result.push(...curve);
   else result.push(corner);
 }
 result.push(points.at(-1)!);
 return result;
}
