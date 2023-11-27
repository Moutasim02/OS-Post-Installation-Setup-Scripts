mkdir Downloads Documents Pictures .ssh VMs

for dir in Downloads Documents Pictures .ssh VMs Development; do
  touch "$dir/test.txt"
done
