*libname master '/neclib/survey/fhdbs/data/allfh/';
*libname me '/home4/pbio/jlink/';
*libname me2 '/home4/pbio/jlink/sasout/allprogs/';
*libname me3 '/home4/pbio/jlink/sasout/ssd01/';
libname me3 '/home3/ocn/rgamble/CSIRO-stats/me3/';
*libname tab '/neclib/survey/fhdbs/tables/';
*libname spak '/spak1/jlink/';
*libname fish '/home4/pbio/jlink/xxxxxxx/';
*change/create directory path of fish for each particular analysis;
*libname port xport '/spak1/jlink/xxxxxx.xpt';
*change name of xport file if want data as ouput beyond just list file;
*e.g. to convert into a cleaner text file via JMP;

libname tryit '/home3/ocn/rgamble/CSIRO-stats/tryit';

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
set tryit.allfh;
*if svspp=135 or svspp=139 or svspp145;
*if svspp<200 or svspp=502 or svspp=503;

if year>1963;


if svspp = 301 then Atcode = 'LOB';
if svspp = 401 then Atcode = 'SCA';
if svspp = 747 then Atcode = 'BFT';
if svspp = 700 then Atcode = 'BIL';
if svspp = 135 then Atcode = 'BLF';
if svspp = 141 then Atcode = 'BSB';
if svspp = 131 then Atcode = 'BUT';
if svspp = 073 then Atcode = 'COD';
if svspp = 015 then Atcode = 'DOG';
if svspp = 104 then Atcode = 'FOU';
if svspp = 197 then Atcode = 'GOO';
if svspp = 074 then Atcode = 'HAD';
if svspp = 101 then Atcode = 'HAL';
if svspp = 032 then Atcode = 'HER';
if svspp = 502 then Atcode = 'ISQ';
if svspp = 026 then Atcode = 'LSK';
if svspp = 503 then Atcode = 'LSQ';
if svspp = 121 then Atcode = 'MAK';
if svspp = 036 then Atcode = 'MEN';
if svspp = 069 then Atcode = 'OHK';
if svspp = 250 then Atcode = 'OPT';
if svspp = 102 then Atcode = 'PLA';
if svspp = 075 then Atcode = 'POL';
if svspp = 353 then Atcode = 'POR';
if svspp = 310 then Atcode = 'RCB';
if svspp = 155 then Atcode = 'RED';
if svspp = 077 then Atcode = 'RHK';
if svspp = 143 then Atcode = 'SCU';
if svspp = 072 then Atcode = 'SHK';
if svspp = 013 then Atcode = 'SMO';
if svspp = 009 then Atcode = 'SSH';
if svspp = 139 then Atcode = 'STB';
if svspp = 103 then Atcode = 'SUF';
if svspp = 177 then Atcode = 'TAU';
if svspp = 860 then Atcode = 'TUN';
if svspp = 151 then Atcode = 'TYL';
if svspp = 076 then Atcode = 'WHK';
if svspp = 106 then Atcode = 'WIF';
if svspp = 192 then Atcode = 'WOL';
if svspp = 108 then Atcode = 'WPF';
if svspp = 023 then Atcode = 'WSK';
if svspp = 107 then Atcode = 'WTF';
if svspp = 105 then Atcode = 'YTF';

if svspp = 043 or svspp = 044 then Atcode = 'ANC';
if svspp = 501 or svspp = 510 or svspp = 511 or svspp = 512 then Atcode = 'BMS';

if svspp = 038 or svspp = 066 or svspp = 124 or svspp = 181 
or svspp = 205 or svspp = 208 or svspp = 209 or svspp = 211 or svspp = 212
or svspp = 213 or svspp = 428 or svspp = 429 or svspp = 466 or svspp = 689 
or svspp = 690 or svspp = 113 or svspp = 046 or svspp = 749 then Atcode = 'BPF';

if svspp = 403 or svspp = 406 or svspp = 407 or svspp = 408 then Atcode = 'CLA';
if svspp = 136 or svspp = 147 or svspp = 149 then Atcode = 'DRM';
if svspp = 007 or svspp = 011 or svspp = 012 or svspp = 014 or svspp = 016 
or svspp = 360 or svspp = 362 or svspp = 925 then Atcode = 'DSH';

if svspp = 031 or (svspp >= 033 and svspp <= 035) or svspp = 037
or svspp = 426 then Atcode = 'FDE';

if svspp = 078 or svspp = 083 or svspp = 084 or svspp = 085 or (svspp >=090 and svspp <=093)
or svspp = 089 or svspp = 099 or svspp = 111 or svspp = 112 or (svspp >=114 and svspp <=117)
or svspp = 119 or svspp = 120 or svspp = 132 or svspp = 133 or svspp = 145 or svspp = 146
or svspp = 146 or svspp = 148 or svspp = 150 or svspp = 153 or svspp = 156
or (svspp >=159 and svspp <= 176) or svspp = 178 or svspp = 179 or svspp = 180
or (svspp >=187 and svspp <=191) or svapp = 194 or svspp = 232 or (svspp >=433 and svspp <=440)
or svspp = 196 or svspp = 876 or svspp = 001 or svspp = 682 or svspp = 185 or svspp = 530
or svspp = 471 or svspp = 631 or svspp = 453 then Atcode = 'FDF';

if svspp = 118 or svspp = 109 or svspp = 110 then Atcode = 'FLA';
if svspp = 056 or svspp = 229 or svspp = 053 or svspp = 054 then Atcode = 'MPF';
if svspp = 306 or svspp = 297 then Atcode = 'NSH';
if svspp = 305 or svspp = 307 or svspp = 913 or svspp = 914 or svspp = 915
then Atcode = 'OSH';

if svspp = 003 or svspp = 352 or svspp = 354 or svspp = 355 or svspp = 357
then Atcode = 'PSH';

if svspp = 409 or svspp = 410 then Atcode = 'QHG';
if svspp = 952 or svspp = 950 then Atcode = 'REP';
if svspp = 063 or svspp = 390 or svspp = 060 or svspp = 384 or svspp = 380 or svspp = 645
then Atcode = 'SDF';

if svspp = 005 or svspp = 020 or svspp = 021 or svspp = 022 or svspp = 024 
or svspp = 025 or svspp = 027 or svspp = 028 then Atcode = 'SK';

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

if gencat = 'PORIFE' or collcat = 'ANTHOZ' or collcat = 'HYDROZ' or analcat='BIVALV' 
or gencat='BRYOZO' or analcat = 'HOLOTH' or gencat = 'UROCHO'
then atlcat = 'BFF';

if pyabbr = 'SPISOL' or collcat = ' MACPOL' then atlcat = 'CLA';
if collcat ='PECFA1' then atlcat = 'SCA'; *scallops;

if collcat = 'HOMAME' then atlcat = 'LOB'; *lobsters;
if collcat = 'ARCISL' or collcat = 'ARCIS3' then atlcat = 'QHG';

if analcat='ASTERO' or analcat = 'PYCNOG' then atlcode = 'BC ';

if analcat = 'ECHIN1' or analcat='GASTRO' then atlcat='BG ';

if collcat='DECCRA' or collcat='CANFAM' or
collcat='CALSAP' or collcat='LIMPOL' or analcat='STOMAT' or collcat='PAGFAM'
or analcat='OPHIU1' or collcat='CEPHAL' then atlcat='BMS';

if collcat = 'ILLILL' then atlcat = 'ISQ';
if collcat = 'LOLPEA' then atlcat = 'LSQ';

if modcat='PELINV' then atlcat='ZL ';
*make sure all the pelagic invert. assigments follow this line;

if collcat ='DECSHR' or collcat='PANFAM' then atlcat='OSH';
if collcat = 'PANBOR' or collcat = 'PANMON' then atlcat = 'NSH';

if collcat='SCYPHOZ' or pyabbr='SIPHON' or analcat='CTENOP' or
gencat='CHAETO' or analcat='LARVAC' then atlcat='ZG ';

if analcat='COPEPO' or collcat = 'PLANKT' then atlcat='ZM ';
if collcat = 'GERQUI' THEN atlcat = 'RCB';

*if gencat ='FISH' then atlcat = 'FDF';
if collcat = 'MALVIL' or collcat = 'AMMDUB' or collcat = 'SCOSAU'
or collcat = 'DECMAC' or collcat = 'DECPUN' or collcat = 'TRALAT'
or collcat = 'ARIBON' or collcat = 'OPIOGL' or collcat = 'SARAUR'
or collcat = 'MUGFAM' or collcat = 'MUGCUR' or collcat = 'ATHFAM'
or collcat = 'MENMEN' or collcat = 'ARGFAM' or collcat = 'ARGSIL'
or collcat = 'ARGSTR' or collcat = 'PEPALE' then atlcat = 'BPF';

if collcat = 'PRPTRI' then atlcat = 'BUT';

if modcat ='LDEM' or modcat = 'SDEM' then atlcat= 'FDF';
*make sure the following lines come after these bigger fish assignements;

if analcat = 'RAJORD' then atlcat = 'SK';
if collcat = 'RAJGAR' then atlcat = 'LSK';
if collcat = 'CENFAB' or collcat = 'ODOTAU' or collcat = 'SHARK' then atlcat = 'DSH';
if collcat = 'CENSTR' then atlcat = 'BSB';
if analcat = 'LOPFAM' then Atlcat = 'GOO';
if collcat = 'MELAEG' then Atlcat = 'HAD';
if collcat = 'TRIMAC' or collcat = 'CITARC' then atlcat = 'FLA';
if collcat = 'PAROBL' then atlcat = 'FOU';
if collcat = 'HIPHIP' then atlcat = 'HAL';
if collcat = 'HIPPLA' then atlcat = 'PLA';
if collcat = 'LIMFER' then Atlcat = 'YTF';
if collcat = 'PARDEN' then atlcat = 'SUF';
if collcat = 'PLEAME' then atlcat = 'WIF';
if collcat = 'SCOAQU' then atlcat = 'WPF';
if collcat = 'GLYCYN' then atlcat = 'WTF';
if collcat = 'GADMOR' then Atlcat = 'COD';
if collcat = 'POLVIR' then atlcat = 'POL';
if collcat = 'SEBFAS' then atlcat = 'RED';
if collcat = 'MERALB' then atlcat = 'OHK';
if collcat = 'UROCHU' then atlcat = 'RHK';
if collcat = 'MORSAX' then atlcat = 'STB';
if collcat = 'TAUONI' then atlcat = 'TAU';
if collcat = 'LOPCHA' then atlcat = 'TYL';
if collcat = 'SALSAL' then atlcat = 'SAL';
if collcat = 'STECHR' then atlcat = 'SCU';
if collcat = 'CONOCE' or collcat = 'CONFAM' or collcat = 'ANGORD' or collcat = 'ANGROS' then atlcat = 'SDF';
if collcat = 'MACAME' then atlcat = 'OPT';
if collcat = 'ANALUP' then atlcat = 'WOL';
if collcat = 'SCIFAM' or collcat = 'MICUND' or collcat = 'LEIXAN' then atlcat = 'DRM';
if collcat = 'MERBIL' then Atlcat = 'SHK';
if analcat = 'SCOFAM' then Atlcat = 'MAK';
if analcat = 'CLUFAM' or analcat = 'OSMFAM' or analcat = 'OSMMOR' then atlcat = 'FDE';
*make sure this comes before the herring assignment;
if collcat='ANCMIT' or collcat='ANCHEP' then atlcat='ANC';
if collcat = 'BRETYR' then atlcat = 'MEN';
if collcat = 'CLUHAR' then Atlcat = 'HER';
if collcat = 'UROTEN' then Atlcat = 'WHK';
if collcat = 'SQUACA' then Atlcat = 'DOG';
if collcat = 'MUSCAN' then atlcat = 'SMO';
if analcat = 'MYCFAM' or collcat='MAUWEI' then atlcat = 'FMM';

if gencat = 'AR' then atlcat = 'WDP';
if collcat = 'THUTHY' then atlcat = 'BFT';
if collcat = 'POMFAM' or collcat = 'POMSAL' then atlcat = 'BLF';

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

