<?php

$buf = file_get_contents(dirname(__FILE__).'/card.tsv');

$lines = explode("\n", $buf);

$res = [];
for ($i = 0; $i < count($lines); $i++) {
  if (empty($lines[$i])) continue;
  list($no, $lv, $name, $u, $l, $r, $d, $elem) = explode("\t", $lines[$i]);
  $e = 0;
  if ($elem == '炎') $e = 1;
  if ($elem == '冷') $e = 2;
  if ($elem == '雷') $e = 3;
  if ($elem == '地') $e = 4;
  if ($elem == '風') $e = 5;
  if ($elem == '聖') $e = 6;
  if ($elem == '水') $e = 7;
  if ($elem == '毒') $e = 8;
  $res[(int)$no] = [
    'lv'   => (int)$lv,
    'name' => $name,
    'up'   => (int)$u,
    'left' => (int)$l,
    'right' => (int)$r,
    'down' => (int)$d,
    'elem' => $e,
  ];
}

file_put_contents(dirname(__FILE__).'/card.json', json_encode($res));
sleep(100);
