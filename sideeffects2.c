#include <stdio.h>

int xandy(int x, int y)
{
	return y = x++;
}


int main(void)
{
	int a = 5;
	int b = 8;
	int c = xandy( a, b);
	return 0;
}
