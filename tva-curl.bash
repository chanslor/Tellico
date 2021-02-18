#!/bin/bash

curl 'https://www.tva.com/RestApi/valley-stream-flows' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'DNT: 1' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: https://www.tva.com/Environment/Lake-Levels/Valley-Stream-Flows' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: ai_user=NNelZiJc/9IpsYGesRevRp|2021-02-16T01:48:39.441Z; sf-prs-ss=637491693865170000; sf-prs-lu=https://www.tva.com/Environment/Lake-Levels/Valley-Stream-Flows; ai_session=EBAEE/0r3JGN9F7DhzXFAe|1613598608876|1613599766421' \
  --compressed --silent -o /tmp/tva.txt


FEET=$(cat /tmp/tva.txt | sed 's/Location/\n/g' | /bin/grep Town | awk -F, ' { print $4 } ' | awk -F\" ' { print $4 } ')
echo $FEET

CFS=$(cat /tmp/tva.txt | sed 's/Location/\n/g' | /bin/grep Town | awk -F, ' { print $5 } ' | awk -F\" ' { print $4 } ')

echo "Current reading: FEET:$FEET  CFS:$CFS"
echo
echo "Inserting into RRD - N:$FEET:$CFS"
echo

if [ ! -f "tempC3.rrd" ]; then
rrdtool create tempC3.rrd \
--step 60 \
DS:FEET:GAUGE:600:0:999999 \
DS:CFS:GAUGE:600:0:999999 \
RRA:AVERAGE:0.5:1:999999 \
RRA:AVERAGE:0.5:3:999999 \
RRA:MIN:0.5:1:999999 \
RRA:MIN:0.5:3:999999 \
RRA:MAX:0.5:1:999999 \
RRA:MAX:0.5:3:999999 \
RRA:LAST:0.5:1:999999 \
RRA:LAST:0.5:3:999999
fi

NOW=`date +%s`

rrdtool update tempC3.rrd N:$FEET:$CFS




/usr/bin/rrdtool graph tempC3.png -t "Tellico" \
--alt-y-grid --alt-autoscale --units-exponent 0 \
-w 600 -h 70 --vertical-label 'FEET' --slope-mode --start -60 \
DEF:ave=tempC3.rrd:FEET:AVERAGE \
CDEF:C=ave,100,GE,ave,0,IF AREA:C#7F0000: \
CDEF:D=ave,95,GE,ave,100,LT,ave,100,IF,0,IF AREA:D#9E0000: \
CDEF:E=ave,90,GE,ave,95,LT,ave,95,IF,0,IF AREA:E#BD0000: \
CDEF:F=ave,85,GE,ave,90,LT,ave,90,IF,0,IF AREA:F#DD0000: \
CDEF:G=ave,80,GE,ave,85,LT,ave,85,IF,0,IF AREA:G#FC0000: \
CDEF:H=ave,75,GE,ave,80,LT,ave,80,IF,0,IF AREA:H#FF1D00: \
CDEF:I=ave,70,GE,ave,75,LT,ave,75,IF,0,IF AREA:I#FC3D00: \
CDEF:J=ave,65,GE,ave,70,LT,ave,70,IF,0,IF AREA:J#FF5C00: \
CDEF:K=ave,60,GE,ave,65,LT,ave,65,IF,0,IF AREA:K#FF7C00: \
CDEF:L=ave,55,GE,ave,60,LT,ave,60,IF,0,IF AREA:L#FFBA00: \
CDEF:M=ave,50,GE,ave,55,LT,ave,55,IF,0,IF AREA:M#FFD900: \
CDEF:N=ave,45,GE,ave,50,LT,ave,50,IF,0,IF AREA:N#FFF900: \
CDEF:O=ave,40,GE,ave,45,LT,ave,45,IF,0,IF AREA:O#E5FF1A: \
CDEF:P=ave,35,GE,ave,40,LT,ave,40,IF,0,IF AREA:P#C6FF39: \
CDEF:Q=ave,30,GE,ave,35,LT,ave,35,IF,0,IF AREA:Q#A6FF58: \
CDEF:R=ave,25,GE,ave,30,LT,ave,30,IF,0,IF AREA:R#87FF78: \
CDEF:S=ave,20,GE,ave,25,LT,ave,25,IF,0,IF AREA:S#69FE96: \
CDEF:T=ave,15,GE,ave,20,LT,ave,20,IF,0,IF AREA:T#49FEB6: \
CDEF:U=ave,10,GE,ave,15,LT,ave,15,IF,0,IF AREA:U#2AFED5: \
CDEF:VV=ave,5,GE,ave,10,LT,ave,10,IF,0,IF AREA:VV#0BFFF4: \
CDEF:WW=ave,0,GE,ave,5,LT,ave,5,IF,0,IF AREA:WW#0BFFF4: \
CDEF:A=ave \
VDEF:V=ave,AVERAGE \
LINE1:ave \
LINE1:A#000000:FEET \
DEF:tmax=tempC3.rrd:FEET:MAX \
DEF:tmin=tempC3.rrd:FEET:MIN \
'GPRINT:ave:LAST:Last\: %2.1lf ft' \
'GPRINT:tmin:MIN:Minimum\: %2.1lf ft' \
'GPRINT:tmax:MAX:Maximum\: %2.1lf ft\j'



