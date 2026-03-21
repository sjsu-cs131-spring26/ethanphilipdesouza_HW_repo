#!/usr/bin/env bash

set -eu

DATA="/mnt/scratch/CS131_jelenag/amazon_reviews_full.tsv"
OUT="out"
TMP="$OUT/tmp"

mkdir -p "$OUT" "$TMP"

awk -F '\t' 'BEGIN{OFS="\t"}
NR==1 {print "review_id","product_id","product_category","star_rating","helpful_votes","total_votes"; next}
NR<=1000 {print $3,$4,$7,$8,$9,$10}
' "$DATA" > "$OUT/task1.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR==1 {print "review_id","product_id","product_category","star_rating","helpful_votes","total_votes"; next}
{
  body=$14
  gsub(/^ +| +$/,"",body)
  if($12=="Y" && length(body)>=30)
    print $3,$4,$7,$8,$9,$10
}' "$DATA" > "$OUT/task2.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 {
  h=$9+0; t=$10+0
  if(t==0) b="NA"
  else {
    r=h/t
    if(r==0) b="ZERO"
    else if(r>=0.8) b="HI"
    else if(r>=0.5) b="MID"
    else if(r>=0.1) b="LO"
    else b="ZERO"
  }
  c[b]++
}
END {
  print "band","count"
  for(b in c) print b,c[b]
}' "$DATA" > "$TMP/t3.tsv"

{ head -n1 "$TMP/t3.tsv"; tail -n+2 "$TMP/t3.tsv" | sort -k2,2nr; } > "$OUT/task3.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 {sum[$4]+=$8; cnt[$4]++}
END {
  print "product_id","count","avg_star_rating"
  for(p in cnt)
    if(cnt[p]>=50)
      printf "%s\t%d\t%.2f\n",p,cnt[p],sum[p]/cnt[p]
}' "$DATA" > "$TMP/t4.tsv"

{ head -n1 "$TMP/t4.tsv"; tail -n+2 "$TMP/t4.tsv" | sort -k3,3nr -k2,2nr; } > "$OUT/task4.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 && $12=="Y" {
  c=$7; s=$8
  k=c SUBSEP s
  cnt[k]++; tot[c]++; cats[c]=1
}
END {
  print "product_category","star_1","star_2","star_3","star_4","star_5","total"
  for(c in cats)
    printf "%s\t%d\t%d\t%d\t%d\t%d\t%d\n",
    c,
    cnt[c SUBSEP 1]+0,
    cnt[c SUBSEP 2]+0,
    cnt[c SUBSEP 3]+0,
    cnt[c SUBSEP 4]+0,
    cnt[c SUBSEP 5]+0,
    tot[c]
}' "$DATA" > "$TMP/t5.tsv"

{ head -n1 "$TMP/t5.tsv"; tail -n+2 "$TMP/t5.tsv" | sort -k7,7nr; } > "$OUT/task5.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 {
  m=substr($15,1,7)
  cnt[m]++; sum[m]+=$8
}
END {
  print "month","count","avg_star_rating"
  for(m in cnt)
    printf "%s\t%d\t%.2f\n",m,cnt[m],sum[m]/cnt[m]
}' "$DATA" > "$TMP/t6.tsv"

{ head -n1 "$TMP/t6.tsv"; tail -n+2 "$TMP/t6.tsv" | sort; } > "$OUT/task6.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 && $12=="Y" {
  t=tolower($14)
  if(t~/broken/) c["broken"]++
  else if(t~/defect/) c["defect"]++
  else if(t~/return/) c["return"]++
  else if(t~/refund/) c["refund"]++
}
END {
  print "keyword","count"
  for(k in c) print k,c[k]
}' "$DATA" > "$TMP/t7.tsv"

{ head -n1 "$TMP/t7.tsv"; tail -n+2 "$TMP/t7.tsv" | sort -k2,2nr; } > "$OUT/task7.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 {
  k=$2 SUBSEP $15
  c[k]++
}
END {
  print "customer_id","date","count"
  for(k in c)
    if(c[k]>=5){
      split(k,a,SUBSEP)
      print a[1],a[2],c[k]
    }
}' "$DATA" > "$TMP/t8.tsv"

{ head -n1 "$TMP/t8.tsv"; tail -n+2 "$TMP/t8.tsv" | sort -k3,3nr; } > "$OUT/task8.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 {
  c=$7; all[c]++
  if($12=="Y") v[c]++
}
END {
  print "product_category","count_all","pct_verified"
  for(c in all)
    printf "%s\t%d\t%.1f\n",c,all[c],(v[c]/all[c])*100
}' "$DATA" > "$TMP/t9.tsv"

{ head -n1 "$TMP/t9.tsv"; tail -n+2 "$TMP/t9.tsv" | sort -k3,3nr; } > "$OUT/task9.tsv"

awk -F '\t' 'BEGIN{OFS="\t"}
NR>1 {
  p=$4; all[p]++
  if($10>0){sum[p]+=$9/$10; cnt[p]++}
}
END {
  print "product_id","count_all","avg_helpfulness_ratio"
  for(p in all)
    if(all[p]>=100 && cnt[p]>0)
      printf "%s\t%d\t%.2f\n",p,all[p],sum[p]/cnt[p]
}' "$DATA" > "$TMP/t10.tsv"

{ head -n1 "$TMP/t10.tsv"; tail -n+2 "$TMP/t10.tsv" | sort -k3,3nr; } > "$OUT/task10.tsv"

rm -rf "$TMP"

echo "Done"
