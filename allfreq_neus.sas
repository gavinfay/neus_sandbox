*libname master '/neclib/survey/fhdbs/data/allfh/';
*libname me '/home4/pbio/jlink/';
*libname me2 '/home4/pbio/jlink/sasout/allprogs/';
*libname me3 '/home4/pbio/jlink/sasout/ssd01/';
libname me3 'C:\Documents and Settings\jlink\My Documents\sasprog\CSIRO-stats\';
*libname tab '/neclib/survey/fhdbs/tables/';
*libname spak '/spak1/jlink/';
*libname fish '/home4/pbio/jlink/xxxxxxx/';
*change/create directory path of fish for each particular analysis;
*libname port xport '/spak1/jlink/xxxxxx.xpt';
*change name of xport file if want data as ouput beyond just list file;
*e.g. to convert into a cleaner text file via JMP;

libname tryit 'C:\Documents and Settings\jlink\My Documents\databases';

*libname catch '/neclib/survey/fhdbs/data/catchdat/';

*filename fact '/neclib/survey/fhdbs/data/allfh/factors.tbl';


*libname master '/neclib/survey/fhdbs/newfhdbs/data/subsets/dietdata/';


 options ls=120 ps=70;

data me3.neusguts /*rem other output file name*/;
set me3.neusguts /*rem other output file name*/;
*if svspp<200 or svspp=502 or svspp=503;


proc sort; by /*byvars*/ /*reg*/ atcode;
*svspp may come before the byvars, but order isn't critical;

data master;
set tryit.allfh03;
*if svspp=135 or svspp=139 or svspp145;
*if svspp<200 or svspp=502 or svspp=503;

if year>1963;


if svspp = 301 then Atcode = 'BML';
if svspp = 401 then Atcode = 'BFS';
if svspp = 197 then Atcode = 'FDD';
if svspp = 074 then Atcode = 'FDO';
if svspp = 105 then Atcode = 'FDF';
if svspp = 073 then Atcode = 'FDS';
if svspp = 072 then Atcode = 'FDB';
if svspp = 121 then Atcode = 'FPL';
if svspp = 032 then Atcode = 'FPS';
if svspp = 076 then Atcode = 'FVD';
if svspp = 135 then Atcode = 'FVS';
if svspp = 015 then Atcode = 'SHB';

if svspp = 305 or svspp = 306 then Atcode = 'PWN';

if (svspp >= 020 and svspp <= 028) or svspp = 004 or svspp = 005 or svspp = 018
or svspp = 019 or svspp = 029 or svspp = 367 or svspp = 368 or 
(svspp >= 370 and svspp <= 378) or svspp = 270 or svspp = 271 or svspp = 924
then Atcode = 'SSK'; 

if svspp = 007 or svspp = 009 or svspp = 011 or svspp = 012 or svspp = 013 or svspp = 014
or svspp = 016 then Atcode = 'SHD'; *rem only partial;

if svspp = 229 or svspp = 056 then Atcode = 'FMM';

if svspp = 501 or svspp = 502 or svspp = 503 then Atcode = 'CEP';

if svspp = 131 or svspp = 031 or svspp = 038 or svspp = 043 
or svspp = 044 or svspp = 181 or svspp = 113 or svspp = 124 or svspp = 466
or svspp = 066 or svspp = 132 or svspp = 428 or svspp = 429 or svspp = 205 
or svspp = 208 or svspp = 209 or svspp = 211 or svspp = 212 or svspp = 213
or svspp = 468 or svspp = 689 or svspp = 690 then Atcode = 'FBP';

if (svspp >= 033 and svspp <= 036) then Atcode = 'FDE';

if svspp = 642 then svspp = 143;

if svspp = 069 or svspp = 075 or svspp = 077 or svspp = 078 or svspp = 083 or svspp = 084
or svspp = 085 or (svspp >= 090 and svspp <= 099) or (svspp >= 111 and svspp <=120) 
or svspp = 132 or svspp = 133 or svspp = 136 or svspp = 141 or svspp = 143 or 
(svspp >= 145 and svspp <= 156) or (svspp >= 159 and svspp <= 180) or (svspp >= 187 and svspp <= 192)
or svspp = 193 or svspp = 194 or svspp = 232 or (svspp >= 433 and svspp <= 440) then
Atcode = 'FDC';

if (svspp >= 101 and svspp <= 104) or (svspp >= 106 and svspp <= 110) then Atcode = 'FVB';

if (svspp >= 510 and svspp <= 515) then Atcode = 'Octo'; *rem to add to BMS;

if Atcode = ' ' then delete;


*lon = lon * -1;
lon = declon;
declon = declon * -1;
lat = declat;

if stratum >= 01310 and stratum <= 01340
then newarea='WSS';
if newarea = 'WSS' then reg = 18;

a = 33/60;
delin = 68 + a;
*lon = declon;
*lat = declat;
if ((stratum = 01360 
or stratum = 01370 
or stratum = 01380) and lon < delin)
then newarea = 'NEG';
if newarea ='NEG' then reg = 17;
*Northeastern Gulf of Maine Basin;

if (((stratum = 01290
or stratum = 01300) and lon >= 67.0)
or
((stratum = 01240
or stratum = 01280) and lon < delin))
then newarea = 'SEG';
if newarea = 'SEG' then reg = 21;
*Southeastern Gulf of Maine Basin;

if ((stratum = 01370 
or stratum = 01380
or stratum = 01360)
and lon >= delin) 
then newarea = 'NWG' ;
if newarea = 'NWG' then reg = 16;
*Northwestern Gulf of Maine Basin;

if ((stratum = 01280
or stratum = 01240) and lon >= delin)
or
(stratum = 01270 and (lon < 70.0))
or (stratum = 03610 and lon < 70)
then newarea = 'SWG';
if newarea = 'SWG' then reg = 20;
*Southwestern Gulf of Maine Basin;

if (stratum = 01290
or stratum = 01300
or stratum = 01220
or stratum= 01210) and lon < 67.0
then newarea='NEC';
if newarea= 'NEC' then reg = 13;
*Northeast Channel;

if (((stratum = 01270  
or  stratum = 01260 
or stratum = 01400) and lon >= 70)
or ((stratum >= 03570 and stratum <= 03750) and lon >= 70)) 
then newarea = 'SGC';
if newarea = 'SGC' then reg = 12;
*Stellwagen Bank, plus Western Gulf of Maine, plus Cape Cod Bay;

if ((stratum = 03880 or stratum = 03890 or stratum = 03900) or
((stratum >= 03840 and stratum <=03870) and lon < delin) or
(stratum = 01390 and lon < delin))
then newarea = 'NCM';
if newarea = 'NCM' then reg = 15;
*Northern Coastal Maine;

if (stratum >= 03760 and stratum <= 03830)
or (stratum = 01390 and lon >= delin)
or (stratum = 01400 and lon < 70.0)
or ((stratum = 03730 or stratum = 03740 or stratum = 03750) and lon < 70)
then newarea = 'CCM';
if newarea = 'CCM' then reg = 14;
*Central Coastal Maine;

b = 57/60;
delin2 = 68 + b;

if stratum = 01250 
or (stratum = 03520 and lon < 70.0)
or stratum = 03550
or stratum = 03560
or (stratum = 01230 and lon >= delin2)
then newarea = 'GSC';
if newarea = 'GSC' then reg = 8;
*Great South Channel;

if (stratum = 01230 and lon < delin2) 
or (stratum = 01210 and lon >= 67.0)
or (stratum = 01220 and lon >= 67.0)
then newarea = 'UGB';
if newarea = 'UGB' then reg = 11;
*Northwestern Flank of Georges Bank;


c = 38/60;
delin3 = 40 + c;

d = 33/60; 
delin4 = 68 + d;

e = 10/60;
delin5 = 41 + e;

f = 4/60;
delin6 = 67 + f;

if stratum = 01190
or stratum = 01200
or (stratum = 01130 and lon >= delin4 and lat >= delin3) 
or (stratum = 01160 and lon >= delin6 and lat >= delin5)
then newarea = 'CGB';
if newarea = 'CGB' then reg = 10;
*Central Georges Bank;

if (stratum = 01130 and lat < delin3 and lon < delin4)
or stratum = 01140
or stratum = 01150
or (stratum = 01160
or stratum = 01170
 or stratum= 01180) and lat < delin5
then newarea = 'SGB';
if newarea = 'SGB' then reg = 9;
*Southern Flank of Georges Bank;

if (stratum >= 01090 and stratum <= 01120)
or stratum = 03460
then newarea = 'NS';
if newarea = 'NS' then reg = 7;
*Nantucket Shoals;


g = 20/60;
delin7 = 73 + g;

h = 27/60;
delin8 = 40 + h;

i = 35/60;
delin9 = 39 + i;

if stratum = 01060 
or stratum = 01070
or stratum = 01080
or ((stratum >= 01010 and stratum <= 01040) and ((lat >= delin8 and lon
< delin7) or (lat >= delin9 and lon < 72.0)))
then newarea = 'SNE';
if newarea = 'SNE' then reg = 6;
*Southern New England;

if ((stratum >= 01010 and stratum <= 01040) and ((lat < delin8 and lon
>= delin7) or (lat < delin9 and lon >= 72.0)))
then newarea = 'HDC';
if newarea = 'HDC' then reg = 4;
*Hudson Canyon;
 
if ((stratum >= 03010 and stratum <= 03050)
or (stratum = 03450 and stratum <=03480)
or stratum = 03530
or stratum = 03510
or stratum = 03500
or stratum = 03540
or stratum = 01050
or (stratum = 03520 and lon >= 70.0)
or
((stratum = 03080
or stratum = 03070
or stratum = 03060) and lon < 72.5))
then newarea = 'NNE';
if newarea = 'NNE' then reg = 5;
*Northern Coastal New England;

if ((stratum = 03090
or stratum = 03100
or stratum = 03110
or stratum = 03120
or stratum = 03130
or stratum = 03140)
or
((stratum = 03080
or stratum = 03070
or stratum = 03060) and lon >= 72.5))
then newarea = 'SCN';
if newarea = 'SCN' then reg = 22;
*Southern Coastal New England;

if (stratum >= 03150 and stratum <= 03410)
then newarea='CMB';
if newarea = 'CMB' then reg = 1;
*Coastal Mid Atlantic Bight;

if (stratum = 01730
or stratum = 01690
or stratum = 01650
or stratum = 01610)
then newarea = 'MAB';
if newarea = 'MAB' then reg = 2;
*Mid Atlantic Bight;

if (stratum >= 01740 and stratum <= 01760)
or (stratum >= 01700 and stratum <= 01720)
or (stratum >= 01660 and stratum <= 01680)
or (stratum >= 01620 and stratum <= 01640)
then newarea = 'OMA';
if newarea = 'OMA' then reg = 3;
*Offshore Mid Atlantic;

if ((stratum = 01160) and (lat>= delin5 and lon <delin6))
or ((stratum = 01170 or stratum=01180) and lat >= delin5)
then newarea = 'NEB';
if newarea = 'NEB' then reg = 19;
*Northeastern Flank of Georges Bank;

****************************************;
if reg = ' ' then delete;

*atlcat = atcode;

if modcat='BENINV' then atlcat='BD ';
if gencat ='ARTHRO' then atlcat ='BD ';
*make sure all the benthic assigments follow this line;

if gencat = 'PORIFE' or collcat = 'ANTHOZ' or collcat = 'HYDROZ' or analcat='BIVALV' 
or gencat='BRYOZO' or analcat = 'HOLOTH' or gencat = 'UROCHO'
then atlcat = 'BFF';

if collcat ='PECFA1' then atlcat = 'BFS'; *scallops;
*make sure this line comes after BFF to pull out scallops from bivalves; 

if collcat = 'HOMAME' then atlcat = 'BML'; *lobsters;

if analcat='ASTERO' /*or analcat='GASTRO'*/ or analcat = 'PYCNOG'
then atlcode = 'BC ';

if analcat = 'ECHIN1' or analcat='GASTRO'
then atlcat='BG ';

if collcat='DECCRA' or collcat='CANFAM' or
collcat='CALSAP' or collcat='LIMPOL' or analcat='STOMAT' or collcat='PAGFAM'
or analcat='OPHIU1' /*or analcat='ASTERO'*/
then atlcat='BMS';



if modcat='PELINV' then atlcat='ZL ';
*make sure all the pelagic invert. assigments follow this line;

if collcat ='DECSHR' or collcat='PANFAM' then atlcat='PWN';

if collcat='SCYPHOZ' or pyabbr='SIPHON' or analcat='CTENOP' or
gencat='CHAETO'  or
analcat='LARVAC' then atlcat='ZG ';

if analcat='COPEPO' or collcat = 'PLANKT' then atlcat='ZM ';

if gencat ='FISH' then atlcat = 'FDC';
if modcat ='SPEL' then atlcat = 'FBP';
if modcat ='LDEM' or modcat = 'SDEM' then atlcat= 'FDC';
*make sure the following lines come after these bigger fish assignements;

if analcat ='CEPHAL' then atlcat = 'CEP';
if analcat = 'RAJORD' then atlcat = 'SSK';

if analcat = 'LOPFAM' then Atlcat = 'FDD';
if collcat = 'MELAEG' then Atlcat = 'FDO';
if analcat = 'PLEORD' or analcat = 'BOTFAM' or analcat ='SOLFAM' or analcat = 'PLEFAM'
then atlcat='FVB';
*make sure this comes before YT assignment;
if collcat = 'LIMFER' then Atlcat = 'FDF';
if collcat = 'GADMOR' then Atlcat = 'FDS';
if collcat = 'MERBIL' then Atlcat = 'FDB';
if analcat = 'SCOFAM' then Atlcat = 'FPL';
if analcat = 'CLUFAM' then atlcat = 'FDE';
*make sure this comes before the herring assignment;
if collcat = 'CLUHAR' then Atlcat = 'FPS';
if collcat = 'UROTEN' then Atlcat = 'FVD';
if analcat = 'POMFAM' then Atlcat = 'FVS';
if collcat = 'SQUACA' then Atlcat = 'SHB';
if analcat = 'MYCFAM' or collcat='MAUWEI' then atlcat = 'FMM';

if gencat = 'AR' then atlcat = 'WDP';

*if any species or byvars limit the analysis, they should be done after this
*set statement and also in allsum;

if pynam='BLOWN' or pynam='PRESERVED' or pynam=' ' then delete;
*if pdgutv<0 then delete;
*if pyvoli=. and pywgti=. and pyperi=. then delete;


*perpyv is likely the best bet for most of our data;
*remember also the regression that normalizes weights and volumes;
* rem caveats of data from sampling;

perpy=perpyw;
pyamt=pyamtw;

proc sort;
by /*byvars*/ cruise station /*reg*/ atcode /*catsex*/ pdid pdlen /*&pycat*/  atlcat  ;

proc means noprint;
var pyamt perpy;
output out=pysum sum=sumpy sumper;
by /*byvars*/ cruise station /*reg*/ atcode /*catsex*/ pdid pdlen /*pycat*/ atlcat;

data pysum; set pysum; drop _TYPE_ _FREQ_;
sumpy2=sumpy*sumpy;
proc sort data=pysum;
by/*byvars*/ /*reg*/ atcode atlcat   ;


proc means data=pysum noprint;
var pdlen sumpy sumper sumpy2;
output out=pyfrq n=freq sum=suml sumpyamt sumperpy sumpyat2;
by /*byvars*/ /*reg*/ atcode atlcat   ;
data pyfrq; set pyfrq;
drop _TYPE_ _FREQ_ suml;

data me3.perfrq; merge me3.neusguts pyfrq;
by /*byvars*/ /*reg*/ atcode;
data me3.perfrq; set me3.perfrq;
if numstom=0 then do;
  avepyamt=0; pyamtvar=.; aveperpy=0; perfrq=0;
end;

else if numstom=1 then do;
  avepyamt=sumpyamt;
  pyamtvar=.;
  aveperpy=sumperpy;
  perfrq=100;
 end;
else do;
  avepyamt=(sumpyamt/numstom);
  pyamtvar=(sumpyat2-((sumpyamt**2)/numstom))/(numstom-1);
  ci=(sqrt(pyamtvar/numstom))*2;
  aveperpy=(sumperpy/numstom);
  perfrq=(freq/numstom)*100;
 end;

proc sort data=me3.perfrq; 
by /*byvars*/ /*reg*/ atcode /*pycats- not essential here,
but helpful for alpha ordering later on*/;

proc means data=me3.perfrq noprint; 
var avepyamt;
output out=totals sum=sumamt;
by /*byvars*/ /*reg*/ atcode;
data totals; set totals; drop _TYPE_ _FREQ_;

data sumstat /*output file name*/;
merge me3.perfrq totals;
by /*byvars*/ /*reg*/ atcode  ;
data sumstat; set sumstat;
if avepyamt=0 then do;
 rave_amt=0;
 relci=.;
 aveperpy=0;
end;
else do;
 rave_amt=(avepyamt/sumamt)*100;
 relci=(ci/sumamt)*100;
end;
*drop sumamt;

data sumstat /*output filename*/;
set sumstat /*output filename*/;
if avepyamt<0 then delete;
proc sort;
by /*reg*/ atcode;

proc print;
var /*byvars*/ /*reg*/ atcode avepyamt rave_amt pyamtvar ci relci aveperpy perfrq freq numstom
/*pycat*/ atlcat;


 run;

