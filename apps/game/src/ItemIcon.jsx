import React from 'react';

const designs = {
  rice: <><path fill="#dcb77e" d="M6 20h28c-1 10-5 15-14 15S7 30 6 20z"/><path fill="#f4e0b3" d="M7 20c3-8 7-10 13-10 5 0 10 3 13 10z"/></>,
  fish: <><path fill="#85a4a2" d="M5 20c8-10 17-10 24 0l7-7v14l-7-7C22 30 13 30 5 20z"/><circle fill="#382a1d" cx="13" cy="18" r="1"/></>,
  grain: <><path fill="#ad8253" d="M11 13l4 4h10l4-4-5-3h-8zM14 19c-2 6-8 9-7 15 1 6 25 6 26 0 1-6-5-9-7-15z"/><path stroke="#f5d082" strokeWidth="2" d="M19 34v-9m0 6-4-3m4 1 4-3M12 18h16"/></>,
  wood: <><path fill="#795037" d="m5 24 18-14 8 3 3 7-19 14zM9 28l17-12 7 2 3 6-17 13z"/><path fill="#d2a171" d="M8 24c6-2 12 8 7 10-6 3-13-6-7-10zm6 5c6-2 12 7 6 8-6 3-11-6-6-8z"/><path d="m17 25 12-9m-8 15 10-8"/></>,
  Inventory: <><path fill="#a27a49" d="M8 16h24v19H8zm0 0 5-7h14l5 7z"/><path stroke="#f6d18c" d="M8 23h24M16 10v25m8-25v25"/><rect fill="#ead099" x="18" y="22" width="4" height="6"/></>,
  Party: <><path fill="#9b7750" d="M4 33v-5l5-3h5l4 3v5zm18 0v-5l4-3h5l5 3v5z"/><circle fill="#d8ad71" cx="11" cy="20" r="4"/><circle fill="#d8ad71" cx="29" cy="20" r="4"/><path fill="#bf9359" d="M13 35v-9l5-3h4l5 3v9z"/><circle fill="#e5c48c" cx="20" cy="16" r="6"/></>
};

export function ItemIcon({kind}) {
  return <svg className="item-emblem" viewBox="0 0 40 40" aria-hidden="true" fill="none" stroke="#493120" strokeWidth="1.6" strokeLinejoin="round">{designs[kind==='flour'?'grain':kind]}</svg>;
}
