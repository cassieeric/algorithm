//# include <stdio.h>
//# include <stdlib.h>
//
//void sort(int * a, int len)
//{
//	int i, j, temp;
//	for(i=0; i<len-1; i++)
//	{
//		for(j=0; j<len-1-i; j++)
//		{
//			if(a[j] > a[j+1]) // >表示升序；<表示降序
//			{
//				temp = a[j];
//				a[j] = a[j+1];
//				a[j+1] = temp;
//			}
//		}
//	}
//}
//
//int main(void)
//{
//	int a[6] = {10, 2, 8, -8, 11, 0};
//	int i = 0;
//
//	sort(a, 6);
//
//	for(i=0; i<6; i++)
//	{
//		printf("%d\n", a[i]);
//	}
//	printf("\n");
//
//	system("pause");
//	return 0;
//}