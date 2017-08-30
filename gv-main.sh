# prepare login information
# I created a dummy login as Randall Amiel or Randy Amiel
g_email="Randall Amiel@gmail.com"
g_password="Randy Amiel"

# login and get token info
curl https://www.google.com/accounts/ClientLogin \
--data-urlencode Email=$g_email --data-urlencode Passwd=$g_password \
-d accountType=GOOGLE \
-d source=Google-cURL-Example \
-d service=grandcentral > token

AUTH=$(sed -n '/Au/s/A/a/p' token)
HEADER="Authorization: GoogleLogin $AUTH"
URL="https://www.google.com/voice/?setup=1#setup/"

# which area codes does Google Voice support?
curl --header "$HEADER" "${URL}?ac=[201-999]&start=0" | grep -ho "+1[0-9]\{10\}" | sort -u >> areacodes
cat areacodes | sed 's/..\(...\)......./\1/' | sort -u
# answer: 201 202 203 205 207 208 209 210 213 214 215 216 218 219 224 225 229 231 234 240 248 251 252 253 254 256 260 262 267 269 270 276 281 301 302 303 304 305 307 312 313 314 315 316 317 318 319 320 321 323 325 330 331 334 336 337 339 347 352 361 385 386 401 402 404 405 406 407 408 409 410 412 413 414 415 419 423 424 425 430 432 434 435 440 443 469 478 480 484 501 502 503 504 505 507 508 509 510 512 513 515 516 518 520 530 540 541 551 559 561 562 563 567 570 571 573 574 575 585 586 601 602 605 607 608 609 612 614 615 616 617 619 623 626 630 631 636 646 650 651 657 660 661 662 678 682 701 702 703 704 706 707 708 713 714 715 716 717 719 720 724 727 731 732 734 740 747 754 757 760 762 763 765 769 772 773 774 775 779 781 785 786 801 802 803 804 805 806 810 812 813 814 815 816 817 818 828 830 831 832 843 845 847 848 850 856 857 858 859 860 862 863 864 865 870 872 901 903 904 906 908 909 910 913 914 915 916 917 918 919 920 925 928 931 936 937 941 949 951 952 954 956 970 971 972 973 978 980 985 989

# add a full number from each area code you want to NUMBERS - I'm interested in 707 or 404 or 646 or 215 or 415
printf "+17540000000\n+19540000000\n" > numbers

# now we use a BFS on each digit to find all numbers
# continue at your own peril!

sed -n 's/+1\(...\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(....\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(.....\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(......\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(.......\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(........\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(.........\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sed -n 's/+1\(.........\).*/\1/p' numbers | sort -u |
(while read LINE; do curl --header "$HEADER" "${URL}?ac=${LINE:0:3}&q=$LINE[0-9]&start=0"; done) | grep -ho "+1[0-9]\{10\}" | sort -u >> numbers

sort -u numbers > sorted; mv sorted numbers

