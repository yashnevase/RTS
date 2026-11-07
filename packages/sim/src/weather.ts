import {clockHour,monsoon} from './travel.ts';
export function campaignWeather(tick:number,longitude=74,seed=1622){
 const day=Math.floor(tick/24),hour=clockHour(tick);
 const roll=(Math.imul(day+seed,1664525)+1013904223)>>>0;
 const night=hour<6||hour>=19;
 const rain=monsoon(tick)&&roll%100<(longitude<74?65:35);
 const fog=!rain&&day%365>=300&&hour>=5&&hour<9&&roll%3===0;
 return {night,rain,fog,label:rain?'Monsoon rain':fog?'Morning mist':night?'Night':'Clear',
   movementPercent:rain?80:fog?90:night?90:100};
}
