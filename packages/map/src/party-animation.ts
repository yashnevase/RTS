export interface MapPoint { x:number; y:number }

/** Plays completed simulation hours in order without advancing a paused view. */
export class CampaignPlayback<T> {
  private hours: T[] = [];
  private elapsed = 0;
  private readonly hourMs: number;

  constructor(hourMs: number) {
    this.hourMs = hourMs;
  }

  enqueue(hour: T) {
    this.hours.push(hour);
  }

  advance(realMs: number, speed: number) {
    if (!this.hours.length || !speed) return [];
    this.elapsed += realMs * speed;
    const completed: T[] = [];
    while (this.hours.length && this.elapsed >= this.hourMs) {
      completed.push(this.hours.shift()!);
      this.elapsed -= this.hourMs;
    }
    if (!this.hours.length) this.elapsed = 0;
    return completed;
  }

  get hour() { return this.hours[0]; }
  get progress() { return this.elapsed / this.hourMs; }
}

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
