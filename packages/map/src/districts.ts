// Map navigation groups only. Preserve the historical types and ownership on each record.
export const districts: Record<string, Record<string, string[]>> = {
  site_pune: { fort_kondhana: ['site_donaje'], fort_purandar: ['site_saswad'] },
  site_ahmadnagar: { fort_ahmadnagar: ['site_bhingar'] },
  site_junnar: { fort_shivneri: ['site_khed'] },
  site_bhor: { fort_rajgad: ['site_gunjavane'], fort_torna: ['site_velhe'] },
  site_chaul: { fort_chaul: [], fort_korlai: ['site_korlai'] },
  site_rajapuri: { fort_janjira: ['site_murud'] },
  site_solapur: { fort_solapur: [] },
  site_daulatabad: { fort_daulatabad: ['site_khirki'] },
  landmark_old_goa: {},
  landmark_burhanpur: {},
};
