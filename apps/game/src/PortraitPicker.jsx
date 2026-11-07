import React from 'react';
export function PortraitPicker({label,value,onChange,options}){
 const selected=options.find(option=>option.id===value);
 return <details className="portrait-picker"><summary><img src={selected?.image??'/art/envoy.webp'} alt=""/>{selected?.name??label}</summary><div>{options.map(option=><button key={option.id} aria-pressed={option.id===value} onClick={e=>{onChange(option.id);e.currentTarget.closest('details').open=false;}}><img src={option.image??'/art/envoy.webp'} alt=""/><span>{option.name}</span></button>)}</div></details>;
}
