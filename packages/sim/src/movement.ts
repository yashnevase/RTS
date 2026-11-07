import {anchor,metres,route,terrain,cell,type Point} from './navigation.ts';
export interface Motion {points:Point[]; index:number; progress:number; destination:string|null}
export function startMotion(from:Point,to:Point,destination:string|null):Motion|null {
 const points=route(from,to,!!destination);
 return points?{points,index:0,progress:0,destination}:null;
}
function effort(a:Point,b:Point) {
 const length=metres(a,b),steps=Math.max(1,Math.ceil(length/1000));
 let total=0;
 for(let i=0;i<steps;i++){
   const t=(i+.5)/steps,id=cell({longitude:a.longitude+(b.longitude-a.longitude)*t,latitude:a.latitude+(b.latitude-a.latitude)*t});
   total+=terrain.cost[id]||10;
 }
 return Math.round(length*total/steps/10);
}
export function position(m:Motion):Point {
 const a=m.points[m.index],b=m.points[m.index+1];
 if(!b)return a;
 const t=Math.min(1,m.progress/Math.max(1,effort(a,b)));
 return {latitude:a.latitude+(b.latitude-a.latitude)*t,longitude:a.longitude+(b.longitude-a.longitude)*t};
}
export function move(m:Motion,budget:number) {
 m.progress+=budget;
 while(m.index<m.points.length-1){
 const length=effort(m.points[m.index],m.points[m.index+1]);
 if(m.progress<length)return false;
 m.progress-=length;m.index++;
 }return true;
}
// Preserve intermediate turns when a single simulation tick crosses waypoints.
export function advanceMotion(m:Motion,budget:number) {
 const startIndex=m.index;
 const start=position(m);
 const arrived=move(m,budget);
 return {arrived,trace:[start,...m.points.slice(startIndex+1,m.index+1),position(m)]};
}
export {anchor};
