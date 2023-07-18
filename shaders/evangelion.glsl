//Khlor's header
//Copyright 2018 GNU GPLv3 https://www.gnu.org/licenses/gpl.txt
//https://github.com/khlorghaal/glslheader/blob/master/header

//vec4 img(vec2 uv){INIT; }
//IMG MUST CALL INIT; ON FIRST LINE

//Define-Switches
#version 130
#define SHADERTOY
#define GLES

uniform float iTime;
uniform vec2 iResolution;

//hack from https://www.shadertoy.com/view/3ll3RH by ttg
//violently jams uniforms into scope
float _iTime= 1.;
vec3 _iResolution= vec3(1.);
#define INIT {_iTime=iTime; _iResolution=iResolution;}
//#define iTime _iTime
//#define iResolution _iResolution

//Consts
#define PI  3.14159265359
#define TAU (PI*2.)
#define PHI 1.61803399
#define deg2rad 0.01745329251
#define SQRT2 (sqrt(2.))
#define BIG 1e8
#define ETA 1e-5
#define eqf(a,b) ( abs((a)-(b))<ETA )

//Aliases
#define fc (gl_FragCoord.xy)
#define res (iResolution.xy)
#define ires ivec2(iResolution.xy)
#define aspect (res.x/res.y)
#define asp aspect
#define aspinv (1./aspect)
#define vec1 float
#define ivec1 int
#define uvec1 uint
#define len length
#define lerp mix
#define norm normalize
#define sat saturate
#define sats saturate_signed
#define smooth(x) smoothstep(0.,1.,x)
#define time float(iTime)
#define mouse ((iMouse.xy-res/2.)/(res*2.))
#define mouse_ang (mouse*TAU)
#define tex texture


//vectorization macros
//I dont use these since I don't trust the optimizer to inline the lambda
//also multiline edit is easy
#define VECTORIZE_UNARY_FLOAT(f) \
vec2 f(vec2 a){ return vec2(f(a.x),f(a.y)); } \
vec3 f(vec3 a){ return vec3(f(a.x),f(a.y),f(a.z)); } \
vec4 f(vec4 a){ return vec4(f(a.x),f(a.y),f(a.z),f(a.w)); }
#define VECTORIZE_BINARY_FLOAT(f) \
vec2 f(vec2 a, vec2 b){ return vec2(f(a.x,b.x),f(a.y,b.y)); } \
vec3 f(vec3 a, vec3 b){ return vec3(f(a.x,b.x),f(a.y,b.y),f(a.z,b.z)); } \
vec4 f(vec4 a, vec4 b){ return vec4(f(a.x,b.x),f(a.y,b.y),f(a.z,b.z),f(a.w,b.w)); }
#define VECTORIZE_UNARY_INT(f) \
ivec2 f(ivec2 a){ return ivec2(f(a.x),f(a.y)); } \
ivec3 f(ivec3 a){ return ivec3(f(a.x),f(a.y),f(a.z)); } \
ivec4 f(ivec4 a){ return ivec4(f(a.x),f(a.y),f(a.z),f(a.w)); }
#define VECTORIZE_BINARY_INT(f) \
ivec2 f(ivec2 a, ivec2 b){ return ivec2(f(a.x,b.x),f(a.y,b.y)); } \
ivec3 f(ivec3 a, ivec3 b){ return ivec3(f(a.x,b.x),f(a.y,b.y),f(a.z,b.z)); } \
ivec4 f(ivec4 a, ivec4 b){ return ivec4(f(a.x,b.x),f(a.y,b.y),f(a.z,b.z),f(a.w,b.w)); }
/* example
float accumulate(float x){ return acc+= x; }
VECTORIZE_UNARY_FLOAT(accumulate);
An impure function is a weird but valid example
*/
#define VECTORIZE_SCALAR_ARG(f) \
vec2 f(vec2 x, vec1 y){ return _f(x,vec2(y));} \
vec3 f(vec3 x, vec1 y){ return _f(x,vec3(y));} \
vec4 f(vec4 x, vec1 y){ return _f(x,vec4(y));}


vec4   srgb(vec4 c){ return pow(c,vec4(   2.2)); }
vec4 unsrgb(vec4 c){ return pow(c,vec4(1./2.2)); }
vec4 texsrgb(sampler2D s,   vec2 uv){ return unsrgb(texture(s,uv)); }
vec4 texsrgb(samplerCube s, vec3  r){ return unsrgb(texture(s, r)); }


vec2 mods(vec2 x, vec1 y){ return mod(x,vec2(y));}
vec3 mods(vec3 x, vec1 y){ return mod(x,vec3(y));}
vec4 mods(vec4 x, vec1 y){ return mod(x,vec4(y));}

vec2 pows(vec2 x, vec1 y){ return pow(x,vec2(y));}
vec3 pows(vec3 x, vec1 y){ return pow(x,vec3(y));}
vec4 pows(vec4 x, vec1 y){ return pow(x,vec4(y));}


 vec2 clamps( vec2 x,  vec1 min,  vec1 max){ return clamp(x,  vec2(min), vec2(max));}
 vec3 clamps( vec3 x,  vec1 min,  vec1 max){ return clamp(x,  vec3(min), vec3(max));}
 vec4 clamps( vec4 x,  vec1 min,  vec1 max){ return clamp(x,  vec4(min), vec4(max));}
ivec2 clamps(ivec2 x, ivec1 min, ivec1 max){ return clamp(x, ivec2(min),ivec2(max));}
ivec3 clamps(ivec3 x, ivec1 min, ivec1 max){ return clamp(x, ivec3(min),ivec3(max));}
ivec4 clamps(ivec4 x, ivec1 min, ivec1 max){ return clamp(x, ivec4(min),ivec4(max));}

 vec2 mins( vec2 v,  vec1 s){ return min(v,  vec2(s));}
 vec3 mins( vec3 v,  vec1 s){ return min(v,  vec3(s));}
 vec4 mins( vec4 v,  vec1 s){ return min(v,  vec4(s));}
 vec2 maxs( vec2 v,  vec1 s){ return max(v,  vec2(s));}
 vec3 maxs( vec3 v,  vec1 s){ return max(v,  vec3(s));}
 vec4 maxs( vec4 v,  vec1 s){ return max(v,  vec4(s));}
 vec2 mins( vec1 s,  vec2 v){ return min(v,  vec2(s));}
 vec3 mins( vec1 s,  vec3 v){ return min(v,  vec3(s));}
 vec4 mins( vec1 s,  vec4 v){ return min(v,  vec4(s));}
 vec2 maxs( vec1 s,  vec2 v){ return max(v,  vec2(s));}
 vec3 maxs( vec1 s,  vec3 v){ return max(v,  vec3(s));}
 vec4 maxs( vec1 s,  vec4 v){ return max(v,  vec4(s));}
ivec2 mins(ivec2 v, ivec1 s){ return min(v, ivec2(s));}
ivec3 mins(ivec3 v, ivec1 s){ return min(v, ivec3(s));}
ivec4 mins(ivec4 v, ivec1 s){ return min(v, ivec4(s));}
ivec2 maxs(ivec2 v, ivec1 s){ return max(v, ivec2(s));}
ivec3 maxs(ivec3 v, ivec1 s){ return max(v, ivec3(s));}
ivec4 maxs(ivec4 v, ivec1 s){ return max(v, ivec4(s));}
ivec2 mins(ivec1 s, ivec2 v){ return min(v, ivec2(s));}
ivec3 mins(ivec1 s, ivec3 v){ return min(v, ivec3(s));}
ivec4 mins(ivec1 s, ivec4 v){ return min(v, ivec4(s));}
ivec2 maxs(ivec1 s, ivec2 v){ return max(v, ivec2(s));}
ivec3 maxs(ivec1 s, ivec3 v){ return max(v, ivec3(s));}
ivec4 maxs(ivec1 s, ivec4 v){ return max(v, ivec4(s));}

float maxv( vec2 a){ return                 max(a.x,a.y)  ;}
float maxv( vec3 a){ return         max(a.z,max(a.x,a.y)) ;}
float maxv( vec4 a){ return max(a.w,max(a.z,max(a.x,a.y)));}
float minv( vec2 a){ return                 min(a.x,a.y)  ;}
float minv( vec3 a){ return         min(a.z,min(a.x,a.y)) ;}
float minv( vec4 a){ return min(a.w,min(a.z,min(a.x,a.y)));}
  int maxv(ivec2 a){ return                 max(a.x,a.y)  ;}
  int maxv(ivec3 a){ return         max(a.z,max(a.x,a.y)) ;}
  int maxv(ivec4 a){ return max(a.w,max(a.z,max(a.x,a.y)));}
  int minv(ivec2 a){ return                 min(a.x,a.y)  ;}
  int minv(ivec3 a){ return         min(a.z,min(a.x,a.y)) ;}
  int minv(ivec4 a){ return min(a.w,min(a.z,min(a.x,a.y)));}

//normalized map to signed
//[ 0,1]->[-1,1]
vec1 nmaps(vec1 x){ return x*2.-1.; }
vec2 nmaps(vec2 x){ return x*2.-1.; }
vec3 nmaps(vec3 x){ return x*2.-1.; }
vec4 nmaps(vec4 x){ return x*2.-1.; }
//normalized map to unsigned
//[-1,1]->[ 0,1]
vec1 nmapu(vec1 x){ return x*.5+.5; }
vec2 nmapu(vec2 x){ return x*.5+.5; }
vec3 nmapu(vec3 x){ return x*.5+.5; }
vec4 nmapu(vec4 x){ return x*.5+.5; }

//[0,1]
float saw(float x){ return mod(x,1.); }
float tri(float x){ return abs( mod(x,2.) -1.); }
  int tri(int x, int a){ return abs( abs(x%(a*2))-a ); }

float sum ( vec2 v){ return dot(v,vec2(1));}
float sum ( vec3 v){ return dot(v,vec3(1));}
float sum ( vec4 v){ return dot(v,vec4(1));}
  int sum (ivec2 v){ return v.x+v.y;}
  int sum (ivec3 v){ return v.x+v.y+v.z;}
  int sum (ivec4 v){ return v.x+v.y+v.z+v.w;}
float prod( vec2 v){ return v.x*v.y;}
float prod( vec3 v){ return v.x*v.y*v.z;}
float prod( vec4 v){ return v.x*v.y*v.z*v.w;}
  int prod(ivec2 v){ return v.x*v.y;}
  int prod(ivec3 v){ return v.x*v.y*v.z;}
  int prod(ivec4 v){ return v.x*v.y*v.z*v.w;}

#define sqrtabs(x) sqrt(abs(x))
#define powabs(x,p) pow(abs(x),p)

vec1 saturate(vec1 x){ return clamp (x, 0.,1.);}
vec2 saturate(vec2 x){ return clamps(x, 0.,1.);}
vec3 saturate(vec3 x){ return clamps(x, 0.,1.);}
vec4 saturate(vec4 x){ return clamps(x, 0.,1.);}
#define lerpsat(a,b,x) lerp(a,b,saturate(x))

vec1 saturate_signed(vec1 x){ return clamp (x, -1.,1.);}
vec2 saturate_signed(vec2 x){ return clamps(x, -1.,1.);}
vec3 saturate_signed(vec3 x){ return clamps(x, -1.,1.);}
vec4 saturate_signed(vec4 x){ return clamps(x, -1.,1.);}

#define smoother(x) (x*x*x * (x*(x*6.-15.)+10.) )


float pow2i(int x){ return float(1<<x); }

//nearest power of
int npo2(float x){ return int(log2(x)); }
int npo3(float x){ return int(log(x)/log(3.)); }

float angle(vec2 v){ return atan(v.y,v.x); }
vec1 angn(vec1 t){ return t-ceil(t/TAU-.5)*TAU; }
vec2 angn(vec2 t){ return t-ceil(t/TAU-.5)*TAU; }

bool real(vec1 x){ return !( isnan(x)||isinf(x) ); }
bool real(vec2 x){ return real(prod(x)); }
bool real(vec3 x){ return real(prod(x)); }
bool real(vec4 x){ return real(prod(x)); }

vec1 rationalize(vec1 x){ return real(x)? x:vec1(0.); }
vec2 rationalize(vec2 x){ return real(x)? x:vec2(0.); }
vec3 rationalize(vec3 x){ return real(x)? x:vec3(0.); }
vec4 rationalize(vec4 x){ return real(x)? x:vec4(0.); }

#define count(_n) for(int n=0; n!=_n; n++)

//im not sure if this is linear or srgb, or if that even matters much
#define LUMVEC vec3(0.2126, 0.7152, 0.0722)
float lum(vec3 c){ return dot(c,vec3(LUMVEC)); }

#define BLACK  vec4(0.,0.,0.,0.)
#define RED    vec4(1.,0.,0.,0.)
#define GREEN  vec4(0.,1.,0.,0.)
#define BLUE   vec4(0.,0.,1.,0.)
#define YELLOW vec4(1.,1.,0.,0.)
#define CYAN   vec4(0.,1.,1.,0.)
#define PURPLE vec4(1.,0.,1.,0.)
#define WHITE  vec4(1.,1.,1.,0.)

vec4 hsv(float h, float s, float v){
    vec4 K= vec4(1., 2./3., 1./3., 3.);
    vec3 p= abs( fract(h+K.xyz)*6. - K.www);
    return vec4( v*lerp(K.xxx, sat(p-K.xxx), s), 1.);
}

#define INT_MAX     0x7FFFFFFF
#define INT_HALFMAX 0x00010000
#define INT_MAXF     float(INT_MAX)
#define INT_HALFMAXF float(INT_HALFMAX)
vec1 unfix16(vec1 x){ return vec1(x)/INT_HALFMAXF; }
vec2 unfix16(vec2 x){ return vec2(x)/INT_HALFMAXF; }
vec3 unfix16(vec3 x){ return vec3(x)/INT_HALFMAXF; }
vec4 unfix16(vec4 x){ return vec4(x)/INT_HALFMAXF; }
ivec1 fixed16(vec1 x){ return ivec1(INT_HALFMAXF*x); }
ivec2 fixed16(vec2 x){ return ivec2(INT_HALFMAXF*x); }
ivec3 fixed16(vec3 x){ return ivec3(INT_HALFMAXF*x); }
ivec4 fixed16(vec4 x){ return ivec4(INT_HALFMAXF*x); }

ivec4 hash(ivec4 x){
	x= ((x>>16)^x)*0x45d9f3b;
	x= ((x>>16)^x)*0x45d9f3b;
	//x=  (x>>16)^x;
    return x;
}
//[-max,+max]->[0,1]
vec1 hashf(vec1 x){ return abs(vec1(hash(ivec4(fixed16(x),0.,0.,0.)).x  ))/INT_MAXF; }
vec2 hashf(vec2 x){ return abs(vec2(hash(ivec4(fixed16(x),0.,0.   )).xy ))/INT_MAXF; }
vec3 hashf(vec3 x){ return abs(vec3(hash(ivec4(fixed16(x),0.      )).xyz))/INT_MAXF; }
vec4 hashf(vec4 x){ return abs(vec4(hash(ivec4(fixed16(x)         ))    ))/INT_MAXF; }

#define R2A vec2(.99231, .9933)
#define R2B vec2(.99111, .9945)
#define R3A vec3(.99312, .98313, .9846)
#define R3B vec3(.99111, .98414, .9935)
#define R4A vec4(.99412, .99343, .99565, .99473)
#define R4B vec4(.99612, .99836, .99387, .99376)
vec1 rand (vec1 x){ return hashf(x);   }
vec2 rand (vec2 x){ return hashf(x*hashf(x+x.yx)); }
vec3 rand (vec3 x){ return hashf(x*1.e2*hashf(R3A+x+x.yzx+x.zxy)); }
vec4 rand (vec4 x){ return hashf(x*hashf(x+x.yzwx+x.zwxy+x.wxyz)); }
vec1 rand1(vec2 x){ return hashf(dot(x*R2A-R2B,-x*R2B+R2A)/x.x);  }
vec1 rand1(vec3 x){ return hashf(dot(x+R3A-R3B,-x+R3B+R3A));  }
vec1 rand1(vec4 x){ return hashf(dot(x+R4A-R4B,-x+R4B+R4A));  }
vec2 rand2(vec1 x){ return hashf(x+R2A);   }
vec3 rand3(vec1 x){ return hashf(x+R3A);   }
float vnse(vec1 x){ return lerp(rand(floor(x)),rand(ceil(x)),fract(x)); }
float vnse(vec2 p){
	vec2 fr= fract(p);
	vec2 f= floor(p);
	vec2 c= ceil(p);
	float nn= rand1(vec2(f.x,f.y));
	float np= rand1(vec2(f.x,c.y));
	float pn= rand1(vec2(c.x,f.y));
	float pp= rand1(vec2(c.x,c.y));
	vec4 v= vec4(nn,np,pn,pp);
	vec2 lx= lerp(v.xy,v.zw, fr.xx);
	return lerp( lx.x,lx.y, fr.y );
}
float vnse(vec3 p){
	vec3 fr= fract(p);
	vec3 f= floor(p);
	vec3 c= ceil(p);
	float nnn= rand1(vec3(f.x,f.y,f.z));
	float nnp= rand1(vec3(f.x,f.y,c.z));
	float npn= rand1(vec3(f.x,c.y,f.z));
	float npp= rand1(vec3(f.x,c.y,c.z));
	float pnn= rand1(vec3(c.x,f.y,f.z));
	float pnp= rand1(vec3(c.x,f.y,c.z));
	float ppn= rand1(vec3(c.x,c.y,f.z));
	float ppp= rand1(vec3(c.x,c.y,c.z));
	vec4 zn= vec4(
		nnn,
		npn,
		pnn,
		ppn
	);
	vec4 zp= vec4(
		nnp,
		npp,
		pnp,
		ppp
	);
	vec4 lx= lerp(zn,zp, fr.zzzz);
	vec2 ly= lerp(lx.xz, lx.yw, fr.yy);
	return lerp(ly.x,ly.y, fr.x);
}

float perlin(vec3 p){
	vec3 fr= fract(p);
	vec3 frn= fr-1.;
	vec3 f= floor(p);
	vec3 c= ceil(p);
	vec3 nnn= nmaps(rand(vec3(f.x,f.y,f.z)));
	vec3 nnp= nmaps(rand(vec3(f.x,f.y,c.z)));
	vec3 npn= nmaps(rand(vec3(f.x,c.y,f.z)));
	vec3 npp= nmaps(rand(vec3(f.x,c.y,c.z)));
	vec3 pnn= nmaps(rand(vec3(c.x,f.y,f.z)));
	vec3 pnp= nmaps(rand(vec3(c.x,f.y,c.z)));
	vec3 ppn= nmaps(rand(vec3(c.x,c.y,f.z)));
	vec3 ppp= nmaps(rand(vec3(c.x,c.y,c.z)));
	float d_nnn= dot(nnn, vec3(fr .x, fr .y, fr .z));
	float d_nnp= dot(nnp, vec3(fr .x, fr .y, frn.z));
	float d_npn= dot(npn, vec3(fr .x, frn.y, fr .z));
	float d_npp= dot(npp, vec3(fr .x, frn.y, frn.z));
	float d_pnn= dot(pnn, vec3(frn.x, fr .y, fr .z));
	float d_pnp= dot(pnp, vec3(frn.x, fr .y, frn.z));
	float d_ppn= dot(ppn, vec3(frn.x, frn.y, fr .z));
	float d_ppp= dot(ppp, vec3(frn.x, frn.y, frn.z));
	vec4 zn= vec4(
		d_nnn,
		d_npn,
		d_pnn,
		d_ppn
	);
	vec4 zp= vec4(
		d_nnp,
		d_npp,
		d_pnp,
		d_ppp
	);
	vec4 lx= lerp(zn,zp, smooth(fr.zzzz));
	vec2 ly= lerp(lx.xz, lx.yw, smooth(fr.yy));
	return nmapu(lerp(ly.x,ly.y, smooth(fr.x)));
}

float worley(vec3 c){
    float acc= 1.;
    vec3 cfl= floor(c);
    vec3 cfr= fract(c);
    for(int i=-1; i<=1; i++){
    for(int j=-1; j<=1; j++){
    for(int k=-1; k<=1; k++){
        vec3 g= vec3(i,j,k)+cfl;
        vec3 p= rand(g)+g;
        float l= len(p-c);
        acc= min(acc,l);
    }}}
	return acc;
}

#define dFdxy(x) (vec2(dFdx(x),dFdy(x)))
#define grad2(f,x) \
	((vec2( \
    	f(x+vec2(ETA,0)), \
		f(x+vec2(0,ETA)) \
	  )-f(x))/ETA)
#define grad3(f,f0,x) \
	((vec3( \
    	f(x+vec3(ETA,0,0)), \
		f(x+vec3(0,ETA,0)), \
		f(x+vec3(0,0,ETA)) \
	  )-f(x))/ETA)

#define gradnorm2(f,x)  \
	norm(vec3(grad2(f,x),1.))
#define gradnorm3(f,x)  \
	norm(grad3(f,x))

mat2 rot2d(float t){
    float c= cos(t);
    float s= sin(t);
    return mat2(
        c,-s,
        s, c
    );
    
}
mat3 rotx(float t){
    float c= cos(t);
    float s= sin(t);
    
    return mat3(
        1, 0, 0,
        0, c,-s,
        0, s, c
    );
}
mat3 roty(float t){
    float c= cos(t);
    float s= sin(t);
    
    return mat3(
         c,0,s,
         0,1,0,
    	-s,0,c
    );
}
mat3 rotz(float t){
    float c= cos(t);
    float s= sin(t);
    
    return mat3(
        c,-s,0,
        s, c,0,
    	0, 0,1
    );
}

//azimuth, inclination
vec3 azincl(vec2 a){
    a.x+= PI/2.;
    vec2 s= sin(a);//sin theta, sin phi
    vec2 c= cos(a);//cos theta, cos phi
    vec3 ret= vec3(c.x,s);
    ret.xy*= c.y;
    return ret;
}

//i am able to use quats, with barely any understanding of them
//versor from axis-angle
vec4 vrsr(vec3 w){
    w.z*= -1.;
	vec3 wn= norm(w);
    float th2= len(w)/2.;
    return vec4(sin(th2)*wn,cos(th2));
}
vec3 rot(vec3 v, vec3 w){
	vec4 q= vrsr(w);
    //copypasta
	return v + 2.*cross(cross(v, q.xyz) + q.w*v, q.xyz);
}

struct ray{
	vec3 a;
    vec3 c;
};

#define FOV 80.
#define FOV_S tan(deg2rad*.5*FOV)
#define NEAR .0

ray look_persp(vec2 uvn, vec2 a){
	ray o;
    o.a= norm( roty(a.x) * rotx(-a.y) * vec3(uvn*FOV_S,1.));
    o.c= o.a*NEAR;
    return o;
}
ray look_orbit(vec2 uvn, vec2 a, float d){
    ray o;
    mat3x3 mat= roty(a.x) * rotx(-a.y);
    o.a= norm( mat * vec3(uvn*FOV_S,1.));
    o.c= mat[2]*-d + o.a*NEAR;
	return o;
}

int doti(ivec2 a, ivec2 b){ return a.x*b.x + a.y*b.y; }
int doti(ivec3 a, ivec3 b){ return a.x*b.x + a.y*b.y + a.z*b.z; }
int doti(ivec4 a, ivec4 b){ return a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w; }

//hacky
int sqrti(int x){return int(sqrt(float(x)));}
int cbrti(int x){return int( pow(float(x),1./3.));}



#ifdef SHADERTOY
//rip from https://www.shadertoy.com/view/llySRh
#define KEY_LEFT   37
#define KEY_UP     38
#define KEY_RIGHT  39  
#define KEY_DOWN   40   
#define KEY_PGUP   33  
#define KEY_PGDOWN 34  
#define KEY_END    35  
#define KEY_HOME   36
#define KEY_SPACE  32
#define keyToggle(ascii)  ( texelFetch(iChannel3,ivec2(ascii,2),0).x > 0.)
#define keyDown(ascii)    ( texelFetch(iChannel3,ivec2(ascii,0),0).x > 0.)
#define keyClick(ascii)   ( texelFetch(iChannel3,ivec2(ascii,1),0).x > 0.)
#endif



/*3d texture hacks
convert spatial position into index, then index into N-spatial position
this artocity is for evading inconvenient storage dimensions

completely trashes cache spatial coherence, as the price of no proper compute.
if someone wanted to be hardcore they could attempt mapping 3d proximity into 2d.*/

//the biggest cube that w*h texels fits
int cubetex_width(){
    return int(pow(res.x*res.y, 1./3.));
}

//cubecoord->texcoord; use for reading
ivec2 cubetex_unpack(ivec3 e){
	int cw= cubetex_width();
	e= clamp(e, ivec3(0), ivec3(cw-1));//assert
	int xw= ires.x;
	int i= e.x+(e.y+e.z*cw)*cw;//1d position
    return ivec2(i%xw, i/xw);
}
//texcoordd->cubecoord; use for writing
//assert(cube_pack(cube_unpack(p))==p);
ivec3 cubetex_pack(ivec2 e){
	int cw= cubetex_width();
	e= clamp(e, ivec2(0), ires-1);//assert
	int xw= ires.x;
	int i= e.x+e.y*xw;
    return ivec3(i%cw, (i/cw)%cw, i/(cw*cw));
}
vec4 cubetex_sample(sampler2D ch, ivec3 p){
    int w= cubetex_width();
    if(minv(p)<=0 || maxv(p)>=w)
        return BLACK;
    //no interpolation unless you want to stare into the glitchvoid
	return texelFetch(ch, cubetex_unpack(p), 0);
}
//given no cache coherence, this operation is quite expensive
vec4 cubetex_sample_trilerp(sampler2D ch, vec3 p){
    int w= cubetex_width();
    //pixel center integer
    //p+= .5;
    //p= floor(p);//!!
    ivec3 ip= ivec3(p);
    vec3 f1= fract(p);
    vec3 f0= 1.-f1;
    float fx0= f0.x;
    float fy0= f0.y;
    float fz0= f0.z;
    float fx1= f1.x;
    float fy1= f1.y;
    float fz1= f1.z;
	vec4 g000= cubetex_sample(ch, ip+ivec3(0,0,0));
	vec4 g001= cubetex_sample(ch, ip+ivec3(0,0,1));
	vec4 g010= cubetex_sample(ch, ip+ivec3(0,1,0));
	vec4 g011= cubetex_sample(ch, ip+ivec3(0,1,1));
	vec4 g100= cubetex_sample(ch, ip+ivec3(1,0,0));
	vec4 g101= cubetex_sample(ch, ip+ivec3(1,0,1));
	vec4 g110= cubetex_sample(ch, ip+ivec3(1,1,0));
	vec4 g111= cubetex_sample(ch, ip+ivec3(1,1,1));

	g000*= fx0*fy0*fz0;
	g001*= fx0*fy0*fz1;
	g010*= fx0*fy1*fz0;
	g011*= fx0*fy1*fz1;
	g100*= fx1*fy0*fz0;
	g101*= fx1*fy0*fz1;
	g110*= fx1*fy1*fz0;
	g111*= fx1*fy1*fz1;
    
    return g000+g001+g010+g011+g100+g101+g110+g111;
}


#undef iTime
#undef iResolution

//BSD license

float sharpen(float x){
	return pow(x, 7.);
}
float circle(vec2 p){
	return sharpen(sat(1.-abs(1.-len(p))));
}
float box(vec2 c){
    vec2 v= c;
	return sharpen(sat(2.-len(v*v)));
}

vec4 eva13(vec2 p){
    if(len(p)>4.)
        return BLACK;
	
	float r;
    
    //halo
	p.y+= .6;
    float c1= circle(p);
    float c2= circle((p+vec2(0.,.5))*2.);
	r= c1+c2;

	//mirror x
    p.x= abs(p.x);
	
	p.y+= 1.25;
	
	float body;
	body+= box((p-vec2(0.,.58))/vec2(.035,.06));//head
	body+= box(            (p-vec2( 0.,.3 ))/vec2(.05,.18));//torso
	body+= box(rot2d( .3 )*(p-vec2( .0,.45))/vec2(.25,.025));//upper humerus
	body+= box(rot2d( .7 )*(p-vec2(.34,.6 ))/vec2(.12,.02));//upper ulna
	body+= box(rot2d(-.5 )*(p-vec2( .0,.5 ))/vec2(.5,.022));//lower arm
	body+= box(rot2d(-.05)*(p-vec2(.05,-.1))/vec2(.03,.3));//leg
	body+= box(rot2d(-.05)*(p-vec2(.11,1.1))/vec2(.01,.6));//pylon
	r+= body;
	
	float lance;
    lance+= box(rot2d(-.3 )*(p-vec2(.45,.4))/vec2(.016,.9));
	r+= lance;

	
	//modeling like this is pretty awful but i dont hate it

	vec4 c= lerp(WHITE,RED, sat(lance));
	
	return vec4(c.rgb, r);
}

vec4 annulus(float r, float th){
	float mip= max(maxv(dFdxy(r)), maxv(dFdxy(th)));
    mip= ceil(mip*res.x);

    float r0= r;

    float v0= r*14. - time*13.;
    float v1= nmapu(sin(v0*8.));//fbm
    float v2= sin(v0*.2)*3.;
	float v3= v0 + v1 + v2;
    float v4= cos(v3);
    float v5= nmapu(v4);
    float v= pow(v5, 4.);
    v= abs(v-.37)*2.;

	float f= r*r*r*.007;//falloff
    
	float h= sin(v0*.1);
    h= nmapu(h);
    h= lerpsat(h, 0., f);
    h= sat(h);
    
    vec4 c= hsv(h,1.,v);

	float b= nmapu(sin(v0*.5));//highlights
    b= pow(b, 80.);
    c+= b*.9;

	c*= sat(r*r);//clear center
	return c;
}

vec4 subsample(vec2 uv){
    vec2 uvn= nmaps(uv);
	vec2 uva= uvn;
    uva.x*= asp;
	
    //hacky perspective
    float z= 1.-uv.y;
    z= (1.1+z)*1.;
	vec2 p= uva*z;
	p.y= p.y*3.-.25;

    
	vec4 c= vec4(.5);
    
    float r= len(p);
    float th= atan(uv.y,uv.x);
    c= annulus(r,th);

	vec4 eva= eva13(uva*10./vec2(1.,.95));
	c= lerp(c, eva, eva.a);
    
    return srgb(c);
}

uniform sampler2D textureImg;

// vec4 subsample(vec2 uv) {
//     return texture2D(textureImg, uv);
// }

vec4 calculateImg(vec2 uv) {
    vec4 s;
    for(int y = 0; y < 3; y++)
        for(int x = 0; x < 3; x++)
            s += subsample(uv + vec2(x, y) / iResolution.xy / 3.0);
    s /= 9.0;
    return s;
}

void main() {
    // Calcul du décalage pour recentrer l'image au milieu de l'écran
    vec2 centerOffset = vec2(.5, .9);
    
    // Obtention des coordonnées UV avec décalage pour recentrer l'image
    vec2 uv = (gl_FragCoord.xy - iResolution.xy * centerOffset) / iResolution.xy;
    
    gl_FragColor = calculateImg(uv);
}


