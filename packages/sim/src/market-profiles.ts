// Preview quantities and calendars. Regional specializations are gameplay assumptions.
export const marketProfiles = {
  site_pune:        {grain:[150,100],wood:[30,80], rice:[15,45],fish:[10,40]},
  site_saswad:      {grain:[20,100], wood:[100,60],rice:[10,35],fish:[8,30]},
  site_ahmadnagar:  {grain:[40,120], wood:[150,80],rice:[5,45], fish:[2,40]},
  site_chaul:       {grain:[30,90],  wood:[45,60], rice:[90,55],fish:[80,50]}
} as const;

export const production = [
  { market:'site_saswad', good:'grain', daily:7, monsoon:5 },
  { market:'site_ahmadnagar', good:'grain', daily:7, monsoon:4 },
  { market:'site_chaul', good:'rice', daily:6, monsoon:4 },
  { market:'site_chaul', good:'fish', daily:8, monsoon:3 }
] as const;
