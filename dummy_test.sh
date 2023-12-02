mkdir Downloads Documents Pictures .ssh VMs Development Desktop

for dir in Downloads Documents Pictures .ssh VMs Development Desktop; do
  touch "$dir/test.txt"
done
