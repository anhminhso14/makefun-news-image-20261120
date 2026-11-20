Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$W = 1024; $H = 1024
$bmp = [System.Drawing.Bitmap]::new($W, $H, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.Color]::FromArgb(8, 17, 28))
function C([string]$hex) { [System.Drawing.ColorTranslator]::FromHtml($hex) }
function Brush([string]$hex) { [System.Drawing.SolidBrush]::new((C $hex)) }
function Pen([string]$hex, [single]$width=1) { [System.Drawing.Pen]::new((C $hex), $width) }
function F([single]$size, [string]$style='Regular') { [System.Drawing.Font]::new('Arial', $size, [System.Drawing.FontStyle]::$style, [System.Drawing.GraphicsUnit]::Pixel) }
function Txt([string]$s, [single]$x, [single]$y, [single]$size, [string]$color='#F4F1E9', [string]$style='Regular') {
  $font=F $size $style; $b=Brush $color
  $g.DrawString($s,$font,$b,[single]$x,[single]$y)
  $font.Dispose(); $b.Dispose()
}
function Line([single]$x1,[single]$y1,[single]$x2,[single]$y2,[string]$color='#27384A',[single]$width=1) {
  $p=Pen $color $width; $g.DrawLine($p,$x1,$y1,$x2,$y2); $p.Dispose()
}
function Box([single]$x,[single]$y,[single]$w,[single]$h,[string]$fill='#111F2E',[string]$edge='#24384A') {
  $path=[System.Drawing.Drawing2D.GraphicsPath]::new()
  $r=12; $path.AddArc($x,$y,$r,$r,180,90); $path.AddArc($x+$w-$r,$y,$r,$r,270,90)
  $path.AddArc($x+$w-$r,$y+$h-$r,$r,$r,0,90); $path.AddArc($x,$y+$h-$r,$r,$r,90,90); $path.CloseFigure()
  $b=Brush $fill; $p=Pen $edge 1; $g.FillPath($b,$path); $g.DrawPath($p,$path); $b.Dispose();$p.Dispose();$path.Dispose()
}
function Dot([single]$x,[single]$y,[single]$r,[string]$color) { $b=Brush $color; $g.FillEllipse($b,$x-$r,$y-$r,$r*2,$r*2);$b.Dispose() }
function Poly([single[]]$coords,[string]$fill='#223A49',[string]$edge='#476475') {
  $pts=[System.Drawing.PointF[]]::new([int]($coords.Length/2))
  for($i=0;$i -lt $pts.Length;$i++){ $pts[$i]=[System.Drawing.PointF]::new($coords[$i*2],$coords[$i*2+1]) }
  $b=Brush $fill;$p=Pen $edge 1.2;$g.FillPolygon($b,$pts);$g.DrawPolygon($p,$pts);$b.Dispose();$p.Dispose()
}
function Label([string]$s,[single]$x,[single]$y,[string]$color='#63D9C5') { Txt $s $x $y 13 $color 'Bold' }

# Masthead and date
Txt 'WORLD / NEWS' 38 24 16 '#68DCC8' 'Bold'
Txt 'FRIDAY  |  GLOBAL DESK' 782 27 14 '#A6B5C2' 'Bold'
Line 38 55 986 55 '#344657' 1
Txt '20' 38 57 48 '#F2CC72' 'Bold'
Txt 'NOVEMBER 2026' 101 71 28 '#F4F1E9' 'Bold'
Txt 'A DAY IN EIGHT STORIES' 728 76 14 '#A6B5C2' 'Bold'

# Lead story: Asia's Friday sell-off, with an original chip-and-market illustration.
Box 34 112 956 258 '#111F2E' '#344758'
Label 'MARKETS  /  ASIA-PACIFIC' 58 132 '#F2CC72'
# Illustration panel
$g.FillRectangle((Brush '#0B1723'),58,160,310,184)
for($i=0;$i -lt 6;$i++){ Line (74+$i*46) 174 (74+$i*46) 329 '#1A2A38' 1 }
for($i=0;$i -lt 4;$i++){ Line 69 (190+$i*38) 354 (190+$i*38) '#1A2A38' 1 }
# Red price line
$points=[System.Drawing.PointF[]]@(
  [System.Drawing.PointF]::new(74,205),[System.Drawing.PointF]::new(120,197),[System.Drawing.PointF]::new(160,215),
  [System.Drawing.PointF]::new(204,208),[System.Drawing.PointF]::new(246,253),[System.Drawing.PointF]::new(287,268),
  [System.Drawing.PointF]::new(349,300))
$lp=Pen '#FF796E' 4;$g.DrawLines($lp,$points);$lp.Dispose()
Dot 246 253 5 '#FF796E'; Dot 349 300 5 '#FF796E'
# Chip icon, abstract and original
Box 102 231 87 70 '#1D3443' '#62D7C2'
Txt 'AI' 124 245 32 '#F4F1E9' 'Bold'
for($i=0;$i -lt 4;$i++){ Line (111+$i*17) 222 (111+$i*17) 231 '#62D7C2' 2; Line (111+$i*17) 301 (111+$i*17) 310 '#62D7C2' 2 }
Txt 'RISK-OFF' 72 316 12 '#A6B5C2' 'Bold'

Txt 'AI FEARS' 402 155 39 '#F4F1E9' 'Bold'
Txt 'HIT ASIA' 402 197 39 '#F4F1E9' 'Bold'
Txt 'Asian shares fell Friday as investors questioned the AI trade.' 402 246 17 '#DCE3E8'
Txt 'Tokyo, Seoul and Taipei slid; the Hang Seng fell nearly 2%' 402 271 16 '#DCE3E8'
Txt 'and Shanghai 1.7% lower after a rough Wall Street session.' 402 294 16 '#DCE3E8'
Txt 'STATUS  -  MARKET MOVES REPORTED BY AP' 402 328 13 '#68DCC8' 'Bold'
Txt 'SOURCE  AP  |  20 NOV, 03:17 UTC' 402 347 12 '#A6B5C2'

# Three centre cards
$cards=@(
  @{x=34;tag='AFRICA  /  WARNING';title=@('ZIMBABWE','MINE CLEARANCE');body=@('HALO Trust says aid cuts','put its 2030 mine-free goal','at risk; 4 percent of land remains.');status='NGO WARNING';source='AFP  |  20 NOV'},
  @{x=357;tag='SOUTH AMERICA  /  OFFICIAL';title=@('BRAZIL RECOGNISES','INDIGENOUS LAND');body=@('Kapot Nhinore declared in','permanent possession of the','Mebengokre and Yudja peoples.');status='GOVERNMENT ACTION';source='AL JAZEERA / AFP  |  20 NOV'},
  @{x=680;tag='EUROPE  /  CYBER';title=@('UK SECURES','COMMERCIAL FRIDGES');body=@('BBC reports a nationwide','operation protected tens of','thousands of devices from hacks.');status='BBC-REPORTED OPERATION';source='BBC  |  20 NOV, 00:02 UTC'}
)
foreach($c in $cards){
  Box $c.x 389 310 212 '#111F2E' '#24384A'; Label $c.tag ($c.x+18) 406
  Txt $c.title[0] ($c.x+18) 432 21 '#F4F1E9' 'Bold'; Txt $c.title[1] ($c.x+18) 456 21 '#F4F1E9' 'Bold'
  Txt $c.body[0] ($c.x+18) 493 15 '#D5DEE5'; Txt $c.body[1] ($c.x+18) 513 15 '#D5DEE5'; Txt $c.body[2] ($c.x+18) 533 15 '#D5DEE5'
  Txt $c.status ($c.x+18) 559 12 '#F2CC72' 'Bold'; Txt $c.source ($c.x+18) 577 11 '#A6B5C2'
}

# Bottom-left map, simplified recognizable continents with six dated story locations.
Box 34 620 458 309 '#111F2E' '#24384A'
Label 'WHERE TODAYS REPORTS LAND' 52 639 '#68DCC8'
Txt 'World locations  |  not a data map' 52 659 12 '#A6B5C2'
# Map projection area x=54..474, y=688..884
Poly ([single[]](110,716,128,697,158,693,176,706,171,723,190,735,181,751,163,756,153,777,138,774,129,758,112,754,99,738,88,730))
Poly ([single[]](169,776,188,782,198,803,191,828,183,852,170,870,158,861,164,841,154,819,158,798))
Poly ([single[]](238,715,252,706,274,710,280,722,267,732,251,729))
Poly ([single[]](245,737,270,737,283,755,278,777,267,798,259,822,244,816,238,794,226,778,229,757))
Poly ([single[]](270,714,291,699,332,699,354,707,379,706,410,718,426,735,413,748,388,746,377,761,356,758,346,774,330,763,317,770,303,755,288,751,280,732))
Poly ([single[]](389,803,411,798,429,807,426,821,407,828,391,821))
# Map points: West Africa, southern Africa, UK, Brazil, California, East Asia.
Dot 239 772 5 '#F2CC72'; Txt 'SENEGAL' 199 779 10 '#F4F1E9' 'Bold'
Dot 272 816 5 '#F2CC72'; Txt 'ZIMBABWE' 277 812 10 '#F4F1E9' 'Bold'
Dot 274 717 5 '#62D7C2'; Txt 'UK' 281 705 10 '#F4F1E9' 'Bold'
Dot 177 811 5 '#62D7C2'; Txt 'BRAZIL' 144 818 10 '#F4F1E9' 'Bold'
Dot 112 727 5 '#FF796E'; Txt 'MALAWI' 67 739 10 '#F4F1E9' 'Bold'
Dot 389 737 5 '#FF796E'; Txt 'ASIA MARKETS' 339 766 10 '#F4F1E9' 'Bold'
Line 52 875 474 875 '#314656' 1
Txt 'CONFIRMED / REPORTED' 54 887 11 '#68DCC8' 'Bold'; Txt 'ATTRIBUTED WARNING' 268 887 11 '#F2CC72' 'Bold'

# Four concise briefs, each with a named source and explicit evidence status.
$small=@(
 @{tag='SENEGAL  /  HUMANITARIAN';headline='4 bodies recovered after boat capsizes';detail='Search continues; death toll may rise.';status='REUTERS-REPORTED';source='AL JAZEERA / REUTERS'},
 @{tag='MALAWI  /  DAILY LIFE';headline='Fuel queues disrupt daily life';detail='Witnesses describe long waits and shortages.';status='FIELD REPORT';source='AL JAZEERA'},
 @{tag='HEALTH  /  EARLY TRIAL';headline='Cancer pill shows early promise';detail='BBC: tumors shrank in some trial patients.';status='NOT AN APPROVED CURE';source='BBC NEWS'},
 @{tag='CURRENCY  /  MARKETS';headline='Dollar nears 19-month high';detail='Reuters links safe-haven demand to AI jitters.';status='MARKET REPORT';source='REUTERS  |  03:47 UTC'}
)
$sy=620
foreach($s in $small){
  Box 508 $sy 482 70 '#111F2E' '#24384A'; Label $s.tag 525 ($sy+8)
  Txt $s.headline 525 ($sy+25) 17 '#F4F1E9' 'Bold'; Txt $s.detail 525 ($sy+45) 13 '#D5DEE5'
  Txt $s.status 842 ($sy+8) 10 '#F2CC72' 'Bold'; Txt $s.source 842 ($sy+47) 10 '#A6B5C2'
  $sy += 78
}

# Ticker with short copy only: keep it comfortably legible at thumbnail scale.
Line 38 948 986 948 '#344657' 1
Txt 'IN BRIEF' 40 961 13 '#F2CC72' 'Bold'
Txt 'Malawi fuel queues  |  Senegal search  |  early trial results  |  dollar gains' 117 959 14 '#D5DEE5'
Txt 'SOURCES: AP  /  AFP  /  BBC  /  AL JAZEERA  /  REUTERS' 40 988 10 '#8193A2'

$out=Join-Path $PSScriptRoot 'entry.png'
$bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose();$bmp.Dispose()
Write-Output "Rendered $out"
