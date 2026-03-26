for i in *.[xX][lL][sS]; do
    echo ${i}
   python3 -W ignore /usr/bin/unoconv -f csv "$i" #"${i%.*}.csv"
done
for i in *.[xX][lL][sS][xX]; do
    echo ${i}
   python3 -W ignore /usr/bin/unoconv -f csv "$i" #"${i%.*}.csv"
done
for i in *.[oO][dD][sS]; do
    echo ${i}
    python3 -W ignore /usr/bin/unoconv -f csv "$i" #"${i%.*}.csv"
done
