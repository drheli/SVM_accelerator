 function result = cordic_tanh(z,N)   
 
 %% [cordic_x,cordic_y,cordic_z]=cordic(x,y,z,m,rotation,iterate)
%% iterate: iterate times
%% rotation: set to 1 with rotation mode; otherwise set to 0 with vector mode.
%% cordic Algorithm for rotation:Z->0
%% m = 1 :(x,y,z)=(1,0,z); x = cos(z) ;y =sin(z)
%% m = 0 :(x,y,z)=(x,0,z);y = x*z
%% m = -1 :(x,y,z)=(1,0,z); x = cosh(z) ; y = sinh(z) ;
%% exp(z) = cosh(z) + sinh(z)
%%-------------------------------------------------------------------------
%% cordic Algorithm for Vector:y->0
%% m = 1 :(x,y,z)=(x,y,0); z = atan(y/x) ; x = (x^2+y^2)^(1/2)/scale
%% m = 0 :(x,y,z)=(x,y,0); z = y/z
%% m = -1 : (y<x),(x,y,z)=(x,y,0); z =atanh(y/x) ; x = (x^2-y^2)^(1/2)/scale
% prepare

num = 0;

%zz_sign = sign(z);
%z = zz_sign*z;

if(abs(z)>=5) 
    result = sign(z);
    return;

else
    while abs(z)>1.13
        num = num + sign(z);
        z = z - sign(z)*log(2);
    end
end
    

m=-1;
x=1;
y=0;

k_initial = 1; 
scale = 1.2075 ;



x=x*scale;

for k = k_initial : N
     if( (mod(k,3)==1) &&( k~=1 ) ) %% in hyperbolic mode ,should iterate twice while k == 3N+1
        for i = 1:2
        
            u=atanh(2^(-k));

        xpre=x;
        ypre=y;
        zpre=z;
        upre=u;
        
        d = sign(zpre);

        x=xpre-m*d*ypre*2^(-k);
        y=ypre+d*xpre*2^(-k);
        z=zpre-d*upre;
        end

    else

        u=atanh(2^(-k));

        xpre=x;
        ypre=y;
        zpre=z;
        upre=u;
        
        d = sign(zpre);

        x=xpre-m*d*ypre*2^(-k);
        y=ypre+d*xpre*2^(-k);
        z=zpre-d*upre;
    end
end

if(num)
    %num = -num;
    cordic_x = 0.5*(x+y)*2^num + 0.5*(x-y)*2^(-num);
    cordic_y = 0.5*(x+y)*2^num + 0.5*(y-x)*2^(-num);
else
    cordic_x = x;
    cordic_y = y;
end

cordic_z=z;

result = cordic_y/cordic_x;
