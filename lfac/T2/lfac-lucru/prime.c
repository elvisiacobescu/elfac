#include "prime.h"

int cmmdc(int a, int b)
{
    int r;
    while(a%b!=0)
    {
	r=a%b;
	a=b;
	b=r;
    }
    return b;
}

int maxim(int a, int b, int c)
{
    return (a>b)?(b>c)?a:(a>c)?a:c:(a>c)?b:(b>c)?b:c;
}

int sumacfr(int a)
{
    if(a<0) a=-a;
    int s=0;
    while(a>0)
    {
	s+=a%10;
	a/=10;
    }
    return s;
}
