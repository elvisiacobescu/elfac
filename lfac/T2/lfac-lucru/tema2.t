integer @abc:=-29;
integer @z:=-10;
integer @afrosamurai;
integer @altcv;
integer @xy:=-7+1;
{
@abc:=maxim(2,3,9);
print(@abc);
@abc:=6+@z+cmmdc(12,cmmdc(12,-@xy));
@z:=@abc*(sumacfr(@z)+1)+6/3-10%4;
@z:=maxim(cmmdc(33,@z),@z,@xy);
@afrosamurai:=sumacfr(@z+234)%13;
print(@z);
print(@abc);
print(@afrosamurai);
@altcv:=-@z*2;
print(@altcv);
print(@xy);
}