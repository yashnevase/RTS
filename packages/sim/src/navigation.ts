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
 const heuristic=(id:number)=>Math.abs(id%grid.width-b%grid.width)+Math.abs(Math.floor(id/grid.width)-Math.floor(b/grid.width));
 while(open.size){
 let current=-1,best=Infinity;
 for(const id of open){const f=costs.get(id)!+heuristic(id)*10;if(f<best){best=f;current=id;}}
 if(current===b){const path=[b];while(path[0]!==a)path.unshift(parents.get(path[0])!);return [start,...path.map(coordinate),snap?end:coordinate(b)];}
 open.delete(current);closed.add(current);
 for(const [dx,dy] of [[1,0],[-1,0],[0,1],[0,-1]]){
 const x=current%grid.width+dx,y=Math.floor(current/grid.width)+dy,id=y*grid.width+x;
 if(x<0||x>=grid.width||y<0||y>=grid.height||!grid.cost[id]||closed.has(id))continue;
 const cost=costs.get(current)!+grid.cost[id];
 if(cost<(costs.get(id)??Infinity)){costs.set(id,cost);parents.set(id,current);open.add(id);}
 }
 }return null;
}
export function metres(a:Point,b:Point) {
 return Math.round(Math.hypot((a.longitude-b.longitude)*105000,(a.latitude-b.latitude)*111000));
}
