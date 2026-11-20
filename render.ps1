Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$W = 1024; $H = 1024
$bmp = [System.Drawing.Bitmap]::new($W, $H, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$paper='#F5F0E4'; $ink='#172A3B'; $muted='#596877'; $rule='#CFC7B7'; $red='#B83D32'; $gold='#BA8A37'; $teal='#297C78'; $blue='#386C9B'; $green='#56835B'; $violet='#70549A'; $orange='#C06C32'
$g.Clear([System.Drawing.ColorTranslator]::FromHtml($paper))
function ColorFromHex([string]$h){[System.Drawing.ColorTranslator]::FromHtml($h)}
function MakeBrush([string]$h){[System.Drawing.SolidBrush]::new((ColorFromHex $h))}
function MakePen([string]$h,[single]$w=1){[System.Drawing.Pen]::new((ColorFromHex $h),$w)}
function MakeFont([single]$sz,[string]$family='Arial',[string]$style='Regular'){[System.Drawing.Font]::new($family,$sz,[System.Drawing.FontStyle]::$style,[System.Drawing.GraphicsUnit]::Pixel)}
function Text([string]$s,[single]$x,[single]$y,[single]$sz,[string]$color=$ink,[string]$style='Regular',[string]$family='Arial'){
  $font=MakeFont $sz $family $style; $brush=MakeBrush $color; $g.DrawString($s,$font,$brush,[single]$x,[single]$y); $font.Dispose();$brush.Dispose()
}
function Rect([single]$x,[single]$y,[single]$w,[single]$h,[string]$fill,[string]$edge=$fill,[single]$ew=1){$br=MakeBrush $fill;$pn=MakePen $edge $ew;$g.FillRectangle($br,$x,$y,$w,$h);$g.DrawRectangle($pn,$x,$y,$w,$h);$br.Dispose();$pn.Dispose()}
function DrawLine([single]$x1,[single]$y1,[single]$x2,[single]$y2,[string]$color=$rule,[single]$w=1){$pn=MakePen $color $w;$g.DrawLine($pn,$x1,$y1,$x2,$y2);$pn.Dispose()}
function Disc([single]$x,[single]$y,[single]$r,[string]$fill,[string]$edge=$fill){$br=MakeBrush $fill;$pn=MakePen $edge 1;$g.FillEllipse($br,$x-$r,$y-$r,$r*2,$r*2);$g.DrawEllipse($pn,$x-$r,$y-$r,$r*2,$r*2);$br.Dispose();$pn.Dispose()}
function Polygon([single[]]$a,[string]$fill,[string]$edge=$fill,[single]$ew=1){$pts=[System.Drawing.PointF[]]::new([int]($a.Length/2));for($i=0;$i -lt $pts.Length;$i++){$pts[$i]=[System.Drawing.PointF]::new($a[$i*2],$a[$i*2+1])};$br=MakeBrush $fill;$pn=MakePen $edge $ew;$g.FillPolygon($br,$pts);$g.DrawPolygon($pn,$pts);$br.Dispose();$pn.Dispose()}
function CTag([string]$s,[single]$x,[single]$y,[string]$color=$teal){Text $s $x $y 12 $color 'Bold'}

function Art([string]$kind,[single]$x,[single]$y,[single]$w,[single]$h){
  $g.SetClip([System.Drawing.RectangleF]::new($x,$y,$w,$h))
  switch($kind){
    'kyiv' {
      Rect $x $y $w $h '#15283C';
      # dusk bands, distant skyline and river
      Rect $x ($y+$h*.62) $w ($h*.38) '#233F53'; Rect $x ($y+$h*.79) $w ($h*.21) '#31576A'
      for($i=0;$i -lt 9;$i++){ $bx=$x+10+$i*($w/9);$bw=24+($i%3)*7;$bh=45+(($i*17)%62);Rect $bx ($y+$h*.72-$bh) $bw $bh '#31495B';for($j=0;$j -lt 3;$j++){Rect ($bx+5+$j*6) ($y+$h*.72-$bh+11) 3 4 '#E5B66A'} }
      # bridge deck and pylons
      DrawLine ($x+$w*.05) ($y+$h*.69) ($x+$w*.96) ($y+$h*.69) '#D3A45C' 3;DrawLine ($x+$w*.18) ($y+$h*.50) ($x+$w*.18) ($y+$h*.70) '#D3A45C' 2;DrawLine ($x+$w*.74) ($y+$h*.46) ($x+$w*.74) ($y+$h*.70) '#D3A45C' 2
      for($i=0;$i -lt 10;$i++){DrawLine ($x+$w*.18) ($y+$h*.52+$i*2.2) ($x+$w*.31+$i*($w*.055)) ($y+$h*.68) '#879A9A' .8;DrawLine ($x+$w*.74) ($y+$h*.48+$i*2) ($x+$w*.61-$i*($w*.055)) ($y+$h*.68) '#879A9A' .8}
      # incoming trail and distant flash, explicitly editorial art
      DrawLine ($x+$w*.67) ($y+$h*.16) ($x+$w*.47) ($y+$h*.36) '#E88969' 3;Disc ($x+$w*.46) ($y+$h*.36) 8 '#F3C46D';Disc ($x+$w*.46) ($y+$h*.36) 15 '#F3C46D' '#F3C46D'
      Rect ($x+$w*.04) ($y+$h*.06) 86 20 '#F5F0E4';Text 'ILLUSTRATION' ($x+$w*.065) ($y+$h*.085) 10 $ink 'Bold'
      Rect ($x+$w*.03) ($y+$h*.87) 138 22 '#F5F0E4';Text 'KYIV  /  01:25 EET' ($x+$w*.055) ($y+$h*.895) 11 $ink 'Bold'
    }
    'markets' {
      Rect $x $y $w $h '#E6EAF0';
      # skyline silhouettes / ticker
      Rect $x ($y+$h*.70) $w ($h*.30) '#D0DBE2'
      for($i=0;$i -lt 8;$i++){ $bx=$x+8+$i*($w/8);$bw=22+($i%2)*13;$bh=32+(($i*23)%50);Rect $bx ($y+$h*.70-$bh) $bw $bh '#7790A1';for($j=0;$j -lt 3;$j++){Rect ($bx+5+$j*7) ($y+$h*.70-$bh+9) 3 4 '#E9D9A7'} }
      $pts=[System.Drawing.PointF[]]@([System.Drawing.PointF]::new($x+$w*.07,$y+$h*.29),[System.Drawing.PointF]::new($x+$w*.25,$y+$h*.35),[System.Drawing.PointF]::new($x+$w*.40,$y+$h*.31),[System.Drawing.PointF]::new($x+$w*.57,$y+$h*.52),[System.Drawing.PointF]::new($x+$w*.72,$y+$h*.49),[System.Drawing.PointF]::new($x+$w*.91,$y+$h*.77));$pn=MakePen $red 4;$g.DrawLines($pn,$pts);$pn.Dispose()
      Text 'ASIA  ↓' ($x+$w*.68) ($y+$h*.08) 15 $red 'Bold'
    }
    'cyclone' {
      Rect $x $y $w $h '#C6DCE2';
      Polygon ([single[]]@(($x+$w*.02),($y+$h*.18),($x+$w*.42),($y+$h*.13),($x+$w*.40),($y+$h*.38),($x+$w*.60),($y+$h*.60),($x+$w*.51),($y+$h*.98),($x+$w*.06),($y+$h*.88))) '#D9C99E' '#A69878'
      Rect ($x+$w*.42) $y ($w*.58) $h '#8DB5C6';
      for($i=0;$i -lt 4;$i++){DrawLine ($x+$w*.80-$i*22) ($y+$h*.05+$i*14) ($x+$w*.50-$i*22) ($y+$h*.49+$i*14) '#F5F0E4' 3}
      Disc ($x+$w*.72) ($y+$h*.48) 25 '#FFF8E6';Disc ($x+$w*.72) ($y+$h*.48) 18 '#568BA3';Disc ($x+$w*.72) ($y+$h*.48) 10 '#FFF8E6';Disc ($x+$w*.72) ($y+$h*.48) 4 '#4A8EA1'
      Text 'ODISHA  •  AKVAN' ($x+$w*.04) ($y+$h*.78) 12 $ink 'Bold'
    }
    'cop' {
      Rect $x $y $w $h '#D8E6DC';
      Disc ($x+$w*.77) ($y+$h*.32) ($h*.22) '#6CA6A2' '#4D897F';DrawLine ($x+$w*.64) ($y+$h*.24) ($x+$w*.90) ($y+$h*.40) '#F5F0E4' 2
      Rect $x ($y+$h*.73) $w ($h*.27) '#5A756A';
      for($i=0;$i -lt 5;$i++){Disc ($x+$w*.17+$i*($w*.14)) ($y+$h*.65) 7 '#203C3C';Rect ($x+$w*.14+$i*($w*.14)) ($y+$h*.68) 15 27 '#203C3C'}
      Rect ($x+$w*.06) ($y+$h*.12) ($w*.42) 33 '#F5F0E4';Text 'COP31  /  ANTALYA' ($x+$w*.09) ($y+$h*.17) 13 $ink 'Bold'
    }
    'fridge' {
      Rect $x $y $w $h '#DEE8E8';Rect ($x+$w*.34) ($y+$h*.12) ($w*.37) ($h*.74) '#FBFCFA' '#527273' 2;DrawLine ($x+$w*.34) ($y+$h*.46) ($x+$w*.71) ($y+$h*.46) '#7E9998' 2;DrawLine ($x+$w*.64) ($y+$h*.25) ($x+$w*.64) ($y+$h*.39) '#527273' 2;DrawLine ($x+$w*.64) ($y+$h*.56) ($x+$w*.64) ($y+$h*.75) '#527273' 2
      Disc ($x+$w*.22) ($y+$h*.28) 13 '#56835B';Text '✓' ($x+$w*.18) ($y+$h*.205) 20 '#FFFFFF' 'Bold';Text 'UK' ($x+$w*.79) ($y+$h*.67) 14 $ink 'Bold'
    }
    'indonesia' {
      Rect $x $y $w $h '#F2E4DC';Rect ($x+$w*.30) ($y+$h*.10) ($w*.40) ($h*.80) '#25394C' '#25394C' 3;Rect ($x+$w*.34) ($y+$h*.17) ($w*.32) ($h*.62) '#E9F0F0';Rect ($x+$w*.39) ($y+$h*.28) ($w*.22) ($h*.21) '#C94438';Polygon ([single[]]@(($x+$w*.47),($y+$h*.32),($x+$w*.47),($y+$h*.45),($x+$w*.55),($y+$h*.385))) '#FFFFFF'
      for($i=0;$i -lt 3;$i++){DrawLine ($x+$w*.10) ($y+$h*.27+$i*16) ($x+$w*.27) ($y+$h*.27+$i*16) '#9F7461' 2}
      Text 'ID' ($x+$w*.77) ($y+$h*.68) 14 $ink 'Bold'
    }
    'quake' {
      Rect $x $y $w $h '#E9E4DD';Rect ($x+$w*.17) ($y+$h*.10) ($w*.66) ($h*.80) '#F9F7F1' '#B4A99B' 2
      DrawLine ($x+$w*.49) ($y+$h*.14) ($x+$w*.43) ($y+$h*.36) '#C94438' 3;DrawLine ($x+$w*.43) ($y+$h*.36) ($x+$w*.55) ($y+$h*.54) '#C94438' 3;DrawLine ($x+$w*.55) ($y+$h*.54) ($x+$w*.45) ($y+$h*.84) '#C94438' 3
      DrawLine ($x+$w*.12) ($y+$h*.57) ($x+$w*.35) ($y+$h*.57) '#527273' 2;DrawLine ($x+$w*.65) ($y+$h*.57) ($x+$w*.90) ($y+$h*.57) '#527273' 2
    }
    'malawi' {
      Rect $x $y $w $h '#E8DFC9';Rect ($x+$w*.16) ($y+$h*.22) ($w*.20) ($h*.52) '#B7533D';Rect ($x+$w*.19) ($y+$h*.12) ($w*.14) ($h*.14) '#B7533D';Rect ($x+$w*.18) ($y+$h*.41) ($w*.17) ($h*.14) '#F4D377';
      for($i=0;$i -lt 4;$i++){Rect ($x+$w*.47+$i*($w*.12)) ($y+$h*.55) ($w*.08) ($h*.18) '#4D6672';Disc ($x+$w*.49+$i*($w*.12)) ($y+$h*.76) 6 '#273742';Disc ($x+$w*.54+$i*($w*.12)) ($y+$h*.76) 6 '#273742'}
      Text 'BLANTYRE' ($x+$w*.54) ($y+$h*.16) 11 $ink 'Bold'
    }
    'shenzhen' {
      Rect $x $y $w $h '#DDE5E5';Rect $x ($y+$h*.73) $w ($h*.27) '#9ABAB6';
      for($i=0;$i -lt 6;$i++){ $bx=$x+8+$i*($w*.15);$bh=30+(($i*19)%45);Rect $bx ($y+$h*.73-$bh) ($w*.11) $bh '#5D7885';for($j=0;$j -lt 2;$j++){Rect ($bx+5+$j*10) ($y+$h*.73-$bh+8) 4 4 '#E6CD87'} }
      Disc ($x+$w*.34) ($y+$h*.36) 22 '#D9A64D';Disc ($x+$w*.65) ($y+$h*.36) 22 '#426F99';DrawLine ($x+$w*.42) ($y+$h*.36) ($x+$w*.57) ($y+$h*.36) '#FFFFFF' 5;Text 'CHINA  ↔  AUSTRALIA' ($x+$w*.18) ($y+$h*.10) 11 $ink 'Bold'
    }
  }
  $g.ResetClip()
}

# Newspaper masthead: warm stock, ink-blue banner, red date block.
Rect 0 0 $W 99 $ink
Rect 25 12 67 69 $red
Text 'NOV' 39 17 13 '#FFFFFF' 'Bold'
Text '20' 36 31 31 '#FFFFFF' 'Bold' 'Georgia'
Text 'FRI' 43 64 11 '#F9E5D8' 'Bold'
Text 'THE DAY IN WORLD NEWS' 111 13 14 '#E7C36D' 'Bold'
Text 'Friday 20 November 2026' 107 28 47 '#FFFFFF' 'Bold' 'Georgia'
Text '8 REPORTS  •  3 CONTINENTS  •  SOURCED & DATE-CHECKED' 111 78 12 '#D4DCE0' 'Bold'
Text 'NEWS CHECK  06:18 UTC  /  13:18 ICT' 773 17 12 '#D9C99E' 'Bold'
Rect 0 96 $W 3 $gold

# Lead story: image left, summary right, matching approved layout.
Rect 24 111 976 267 '#FFFFFF' '#AFA695' 1
Art 'kyiv' 34 121 442 247
Rect 492 121 497 247 '#F8F5ED'
Rect 492 121 497 26 $red
Text '01  EUROPE  /  UKRAINE WAR' 506 126 13 '#FFFFFF' 'Bold'
Text 'RUSSIA NIGHT' 511 158 32 $ink 'Bold' 'Georgia'
Text 'ATTACK HITS KYIV' 511 190 32 $ink 'Bold' 'Georgia'
Rect 511 231 456 5 $gold
Text 'A mass missile and drone assault struck Kyiv before dawn.' 511 246 16 $ink 'Regular' 'Georgia'
Text 'Officials reported 3 killed and about 15 injured; bridges' 511 270 15 $ink 'Regular' 'Georgia'
Text 'and critical services were damaged, including power, heat' 511 291 15 $ink 'Regular' 'Georgia'
Text 'and water. Casualties are attributed to city officials.' 511 312 15 $ink 'Regular' 'Georgia'
Rect 511 341 456 26 '#E9E3D7'
Text 'KYIV INDEPENDENT  •  UPDATED 07:52 EET  •  OFFICIAL TOLL' 520 347 11 $ink 'Bold'

# Three medium cards, each with a distinct visual and source/date strip.
$mid=@(
  @{x=24;color=$blue;tag='02  ASIA  /  MARKETS';art='markets';title1='ASIA SHARES';title2='SLIDE ON AI FEARS';body1='Nikkei and Kospi fell 4.5%;';body2='Hang Seng lost nearly 2%.';src='AP  •  03:17 UTC'},
  @{x=354;color=$orange;tag='03  INDIA  /  CYCLONE';art='cyclone';title1='AKVAN CROSSES';title2='EAST INDIA COAST';body1='Near Gopalpur; IMD reports';body2='70–80 km/h winds, rain risk.';src='ODISHA TV / IMD  •  09:51 IST'},
  @{x=684;color=$teal;tag='04  CLIMATE  /  COP31';art='cop';title1='COP31 ENTERS';title2='FINAL DAY';body1='Nations press for deeper';body2='fossil-fuel cuts in Antalya.';src='AP  •  01:18 TRT'}
)
foreach($m in $mid){
  Rect $m.x 391 316 223 '#FFFFFF' '#BDB5A5';Rect $m.x 391 316 24 $m.color;Text $m.tag ($m.x+10) 396 12 '#FFFFFF' 'Bold'
  Art $m.art ($m.x+10) 422 296 90
  Text $m.title1 ($m.x+12) 518 18 $ink 'Bold' 'Georgia';Text $m.title2 ($m.x+12) 539 18 $ink 'Bold' 'Georgia'
  Text $m.body1 ($m.x+12) 562 13 $muted;Text $m.body2 ($m.x+12) 578 13 $muted
  Rect ($m.x+10) 597 296 12 '#EEE9DE';Text $m.src ($m.x+14) 597 10 $ink 'Bold'
}

# Bottom left: a clean, proportioned equirectangular locator map with numbered report pins.
Rect 24 630 465 346 '#FFFFFF' '#BDB5A5'
Rect 24 630 465 29 $ink
Text 'WHERE IT HAPPENED' 38 637 15 '#FFFFFF' 'Bold'
Text '8 pinned report locations  /  numbered to match cards' 38 665 12 $muted
# map panel
Rect 38 688 437 222 '#EAF1F1' '#D3DEDC'
# latitude/longitude graticule
for($i=1;$i -le 3;$i++){DrawLine 46 (688+$i*53) 467 (688+$i*53) '#D4DFDC' .8}
for($i=1;$i -le 5;$i++){DrawLine (38+$i*72.8) 694 (38+$i*72.8) 904 '#D4DFDC' .8}
# recognizable simplified continent silhouettes, kept in geographic proportions
Polygon ([single[]](72,730,91,713,123,704,151,714,169,733,159,746,142,750,136,766,117,772,100,760,84,758,68,744)) '#C5D3C9' '#9BAFA8'
Polygon ([single[]](133,773,153,780,168,803,163,833,153,859,140,883,128,868,131,842,120,818,121,793)) '#C5D3C9' '#9BAFA8'
Polygon ([single[]](205,714,222,706,243,712,247,723,234,733,214,730)) '#C5D3C9' '#9BAFA8'
Polygon ([single[]](218,737,245,735,262,751,258,779,246,805,236,835,222,825,218,798,207,781,208,757)) '#C5D3C9' '#9BAFA8'
Polygon ([single[]](244,716,267,704,302,704,327,711,355,709,380,722,398,739,390,753,367,755,356,772,337,767,323,779,304,769,292,751,271,745,257,730)) '#C5D3C9' '#9BAFA8'
Polygon ([single[]](368,815,392,809,415,818,412,836,389,845,370,834)) '#C5D3C9' '#9BAFA8'
# pins plotted using 0..360 longitude / -60..85 latitude transformed into the map rectangle
function Pin([int]$n,[double]$lon,[double]$lat,[string]$color){$px=46+([double]($lon+180)/360)*421;$py=696+((84-$lat)/144)*198;Disc $px $py 8.5 $color '#FFFFFF';$s=('{0:d2}' -f $n);$f=MakeFont 8 'Arial' 'Bold';$br=MakeBrush '#FFFFFF';$sz=$g.MeasureString($s,$f);$g.DrawString($s,$f,$br,[single]($px-$sz.Width/2),[single]($py-$sz.Height/2-1));$br.Dispose();$f.Dispose()}
$editionAudit=@(
  @{id=1;day='2026-11-20';source='Kyiv Independent';basis='officials attributed';lon=30.5;lat=50.45;color=$red},
  @{id=2;day='2026-11-20';source='Associated Press';basis='market snapshot';lon=121.47;lat=31.23;color=$blue},
  @{id=3;day='2026-11-20';source='Odisha TV / IMD';basis='agency attributed';lon=84.8;lat=19.1;color=$orange},
  @{id=4;day='2026-11-20';source='Associated Press';basis='summit status';lon=30.7;lat=36.9;color=$teal},
  @{id=5;day='2026-11-20';source='BBC';basis='reported operation';lon=-2;lat=54;color=$green},
  @{id=6;day='2026-11-20';source='Reuters';basis='early report';lon=139.7;lat=35.7;color=$violet},
  @{id=7;day='2026-11-20';source='Al Jazeera';basis='witness reporting';lon=35;lat=-15;color=$gold},
  @{id=8;day='2026-11-20';source='Reuters';basis='attributed quote';lon=114.1;lat=22.5;color=$red}
)
foreach($story in $editionAudit){Pin $story.id $story.lon $story.lat $story.color}
# panel annotations and legend reinforce that points locate the named reports, not casualty data
Text '01 Kyiv' 43 922 12 $red 'Bold';Text '02 Asia markets' 126 922 12 $blue 'Bold';Text '03 Odisha' 255 922 12 $orange 'Bold';Text '04 Antalya' 356 922 12 $teal 'Bold'
Text '05 UK' 43 946 12 $green 'Bold';Text '06 Tokyo' 126 946 12 $violet 'Bold';Text '07 Malawi' 255 946 12 $gold 'Bold';Text '08 Shenzhen' 356 946 12 $red 'Bold'

# Exactly four compact, illustrated briefs to the map's right.
$small=@(
  @{y=630;color=$green;tag='05  UK  /  CYBERSECURITY';art='fridge';title='UK secures fridge networks';body='Tens of thousands shielded from hackers.';source='BBC  •  00:02 UTC'},
  @{y=716;color=$violet;tag='06  JAPAN  /  EARTHQUAKE';art='quake';title='M4.5 quake jolts Tokyo';body='No immediate damage; no tsunami warning.';source='REUTERS  •  03:01 UTC'},
  @{y=802;color=$gold;tag='07  MALAWI  /  FUEL';art='malawi';title='Fuel queues snarl daily life';body='Blantyre drivers wait hours amid shortages.';source='AL JAZEERA  •  20 NOV'},
  @{y=888;color=$red;tag='08  CHINA–AUSTRALIA  /  DIPLOMACY';art='shenzhen';title='Xi says ties with Australia have turned around';body='Remarks followed a Friday meeting with Albanese.';source='REUTERS  •  20 NOV'}
)

# Check that every numbered pin has a dated source row and a clear evidence label.
function Validate-Edition([object[]]$stories,[object[]]$cards){
  if($stories.Count -ne 8){throw 'The map and source register must describe exactly eight stories.'}
  $ids=@($stories | ForEach-Object {$_.id} | Sort-Object -Unique)
  if(($ids -join ',') -ne '1,2,3,4,5,6,7,8'){throw 'Story ids must be unique and run from 01 to 08.'}
  $sourceFile=Join-Path $PSScriptRoot 'SOURCES.md'
  if(-not (Test-Path -LiteralPath $sourceFile)){throw 'SOURCES.md is required beside the image renderer.'}
  $sourceText=Get-Content -LiteralPath $sourceFile -Raw -Encoding UTF8
  foreach($story in $stories){
    if($story.day -ne '2026-11-20'){throw "Story $($story.id) is outside the edition date."}
    if([string]::IsNullOrWhiteSpace($story.source)){throw "Story $($story.id) has no named source."}
    if([string]::IsNullOrWhiteSpace($story.basis)){throw "Story $($story.id) has no evidence attribution."}
    if($story.lon -lt -180 -or $story.lon -gt 180 -or $story.lat -lt -60 -or $story.lat -gt 85){throw "Story $($story.id) has an invalid map coordinate."}
    $storyKey='{0:d2}' -f $story.id
    if($sourceText -notmatch "(?m)^\|\s*$storyKey\s*\|"){throw "Story $storyKey has no matching row in SOURCES.md."}
    if($cards -notcontains ('{0:d2}' -f $story.id)){throw "Story $($story.id) has no matching numbered image card."}
  }
  return $true
}
$cardIds=@('01')+@($mid | ForEach-Object {$_.tag.Substring(0,2)})+@($small | ForEach-Object {$_.tag.Substring(0,2)})
if(-not (Validate-Edition $editionAudit $cardIds)){throw 'Edition validation failed.'}

foreach($s in $small){
  Rect 505 $s.y 495 78 '#FFFFFF' '#BDB5A5'
  Rect 505 $s.y 495 20 $s.color;Text $s.tag 515 ($s.y+4) 11 '#FFFFFF' 'Bold'
  Art $s.art 515 ($s.y+25) 82 46
  Text $s.title 607 ($s.y+25) 15 $ink 'Bold' 'Georgia'
  Text $s.body 607 ($s.y+46) 11.5 $muted
  Text $s.source 607 ($s.y+62) 9.5 $ink 'Bold'
}

# restrained footer, no speculative headline strip
DrawLine 24 987 1000 987 $ink 1
Text 'DATE CHECK  /  EVENTS OR FIRST REPORTS: FRI 20 NOVEMBER 2026' 30 993 10 $ink 'Bold'
Text 'EDITORIAL ILLUSTRATIONS  •  ATTRIBUTED CLAIMS LABELED  •  SOURCES IN SOURCES.MD' 521 993 10 $muted 'Bold'

$out=Join-Path $PSScriptRoot 'entry.png'
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose();$g.Dispose()
# Verify the delivered artifact contract immediately after rendering.
if(-not (Test-Path -LiteralPath $out)){throw 'Renderer did not create entry.png.'}
$imageFile=[System.Drawing.Image]::FromFile($out)
try {
  if($imageFile.Width -ne 1024 -or $imageFile.Height -ne 1024){throw 'entry.png must be exactly 1024 by 1024 pixels.'}
} finally {$imageFile.Dispose()}
$imageBytes=(Get-Item -LiteralPath $out).Length
if($imageBytes -gt 1048576){throw 'entry.png must not exceed one mebibyte.'}
if($imageBytes -lt 4096){throw 'entry.png is unexpectedly small for the editorial layout.'}
Write-Output "Verified entry.png: 1024x1024, $imageBytes bytes, eight dated/source-checked cards."
$g.Dispose();$bmp.Dispose()
Write-Output "Rendered $out"
