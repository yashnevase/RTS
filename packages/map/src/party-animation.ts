export interface MapPoint { x:number; y:number }

export function sampleTrail(points:readonly MapPoint[], progress:number) {
  if (points.length===1) return {...points[0],heading:0};
  const lengths=points.slice(1).map((point,index)=>Math.hypot(point.x-points[index].x,point.y-points[index].y));
  const total=lengths.reduce((sum,length)=>sum+length,0);
  let distance=Math.max(0,Math.min(1,progress))*total;
  for(const [index,length] of lengths.entries()){
    if(length===0) continue;
    if(distance<=length){
      const a=points[index],b=points[index+1],t=distance/length;
      return {x:a.x+(b.x-a.x)*t,y:a.y+(b.y-a.y)*t,heading:Math.atan2(b.y-a.y,b.x-a.x)};
    }
    distance-=length;
  }
  return {...points[points.length-1],heading:0};
}
