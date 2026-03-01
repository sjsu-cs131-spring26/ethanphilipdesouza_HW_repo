# Part A - Globbing
touch notes.txt note1.txt noteA.md .bashrc fake.tsv
ls note?.txt

# Find commands
find . -name "*.tsv"
find . -size +1M
find . -mtime -1

# -exec vs xargs
mkdir logs
unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -1000 > logs/a.log
unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -1000 > logs/b.log
unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -1000 > logs/c.log
find logs -name "*.log" -exec wc -l {} \;
find logs -name "*.log" | xargs wc -l

# Part B - Create 10k sample
(unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | head -n1 && unzip -p /mnt/scratch/CS131_jelenag/amazon_reviews_multilingual_US_v1_00.tsv.zip | tail -n +2 | shuf -n 10000) > amazon_reviews_10k_random_hw4.tsv

grep -E "great(est)?" amazon_reviews_10k_random_hw4.tsv | wc -l
cut -f6 amazon_reviews_10k_random_hw4.tsv | grep -E "^[A-Z]"
cut -f13 amazon_reviews_10k_random_hw4.tsv | grep -E "[0-9]$" | wc -l
grep -vi "return" amazon_reviews_10k_random_hw4.tsv | wc -l

# Part C - Pipelines
mkdir -p out
cut -f8 amazon_reviews_10k_random_hw4.tsv | sort | uniq -c | sort -nr
cut -f8 amazon_reviews_10k_random_hw4.tsv | sort | uniq -c | sort -nr | tee out/hist_star_10k.txt

cut -f5 amazon_reviews_10k_random_hw4.tsv | sort | uniq -c | sort -nr | head

cut -f5,6 amazon_reviews_10k_random_hw4.tsv | sort -t $'\t' -k1,1 | uniq > pid_title.tsv
cut -f5 amazon_reviews_10k_random_hw4.tsv | sort | uniq -c | sort -nr | awk '{print $2"\t"$1}' | sort -t $'\t' -k1,1 > pid_count.tsv
join -t $'\t' -1 1 -2 1 pid_count.tsv pid_title.tsv

head -5000 amazon_reviews_10k_random_hw4.tsv | cut -f5 | sort > first.txt
tail -5000 amazon_reviews_10k_random_hw4.tsv | cut -f5 | sort > second.txt
comm -23 first.txt second.txt | wc -l
comm -13 first.txt second.txt | wc -l
comm -12 first.txt second.txt | wc -l

# Part D - IDs
mkdir -p ids/CUSTOMERS ids/PRODUCTS
grep -F "10001556" amazon_reviews_10k_random_hw4.tsv | cut -f8 > ids/CUSTOMERS/10001556.txt
grep -F "10002228" amazon_reviews_10k_random_hw4.tsv | cut -f8 > ids/CUSTOMERS/10002228.txt
grep -F "10004235" amazon_reviews_10k_random_hw4.tsv | cut -f8 > ids/CUSTOMERS/10004235.txt

grep -F "600633062" amazon_reviews_10k_random_hw4.tsv | cut -f8 > ids/PRODUCTS/600633062.txt
grep -F "245449872" amazon_reviews_10k_random_hw4.tsv | cut -f8 > ids/PRODUCTS/245449872.txt
grep -F "46324555" amazon_reviews_10k_random_hw4.tsv | cut -f8 > ids/PRODUCTS/46324555.txt

# Part E - Permissions
mkdir share
chmod 770 share
touch share/file1.txt share/file2.txt
mkdir share/subdir
chmod -R 770 share
ln share/file1.txt share/hardlink.txt
ln -s share/file1.txt share/symlink.txt
ls -li share

# Part F - I/O
echo "hello" > test.txt
echo "world" >> test.txt
ls fakefile 2> error.txt
ls fakefile &> both.txt
cut -f8 amazon_reviews_10k_random_hw4.tsv | sort | uniq -c | tee stars_output.txt | wc -l
