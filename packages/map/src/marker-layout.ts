export interface MarkerBox {x:number;y:number;width:number;height:number}
export function separateMarker(desired:MarkerBox,placed:readonly MarkerBox[]){
 for(let ring=0;ring<=8;ring++)for(const [dx,dy] of [[1,0],[-1,0],[0,1],[0,-1],[1,1],[-1,1]]){
   const candidate={...desired,x:desired.x+ring*24*dx,y:desired.y+ring*22*dy};
   if(!placed.some(b=>candidate.x-candidate.width/2<b.x+b.width/2+12&&candidate.x+candidate.width/2>b.x-b.width/2-12&&candidate.y-candidate.height<b.y+24&&candidate.y>b.y-b.height-12))return candidate;
 }
 return {...desired,y:desired.y+220};
}
