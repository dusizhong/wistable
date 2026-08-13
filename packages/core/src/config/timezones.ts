import momentTimezone from 'moment-timezone';

export const covertDayjsFormat2DateFnsFormat = (format: string) => {
  return format.replace('YYYY', 'yyyy').replace('YY', 'yy').replace('DD', 'dd');
};

export const isValidTimezone = (timezone: string) => {
  return momentTimezone.tz.zone(timezone) != null;
};

export const getTimeZone = () => {
  const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  return isValidTimezone(timeZone) ? timeZone : '';
};

export const getTimeZoneOffsetByUtc = (utc: string, isdstDate?: boolean) => {
  const currentTimeZoneData = TIMEZONES.find((tz) => tz.utc.includes(utc));
  const dstDiff = currentTimeZoneData?.isdst ? isdstDate ? 0 : -1 : 0;
  return currentTimeZoneData ? currentTimeZoneData.offset + dstDiff : 0;
};

export const getTimeZoneAbbrByUtc = (utc: string) => {
  const abbr = momentTimezone.tz(utc).zoneAbbr();
  const abbrNum = Number(abbr);
  if (isNaN(abbrNum)) {
    return abbr;
  }
  return `UTC${abbrNum > 0 ? '+' : ''}${abbrNum}`;
};

export const getUtcOptionList = () => {
  const list: { abbr: string; offset: number; label: string; value: string }[] = [];

  for (const tz of TIMEZONES) {
    for (const utc of tz.utc) {
      if (utc.includes('Etc/GMT')) continue;
      list.push({
        abbr: tz.abbr,
        offset: tz.offset,
        label: `UTC${tz.offset > 0 ? '+' : ''}${tz.offset}(${utc})`,
        value: utc,
      });
    }
  }

  return list;
};

export const getClientTimeZone = () => {
  const clientTimeZone = getTimeZone();
  const currentTimeZoneData = TIMEZONES.find((tz) => tz.utc.includes(clientTimeZone));
  if (!currentTimeZoneData) {
    return '';
  }
  const { offset } = currentTimeZoneData;
  return `UTC${offset > 0 ? '+' : ''}${offset}(${clientTimeZone})`;
};

export const formatTimeZone = (timeZone: string) => {
  const currentTimeZoneData = TIMEZONES.find((tz) => tz.utc.includes(timeZone));
  if (!currentTimeZoneData) {
    return '';
  }
  const { offset } = currentTimeZoneData;
  return `UTC${offset > 0 ? '+' : ''}${offset}(${timeZone})`;
};


export const TIMEZONES = [
  { abbr: 'CST', offset: 8, isdst: false, utc: ['Asia/Shanghai'] },
];
