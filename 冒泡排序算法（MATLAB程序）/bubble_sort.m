a = [7, 11, 8, 18, 12];
for i = 1:1:length(a)
  for j = i+1:1:length(a)
    if a[i] > a[j]
      temp = a[i];
      a[i] = a[j];
      a[j] = temp;
     end
   end
 end
 
a;  # 输出a
