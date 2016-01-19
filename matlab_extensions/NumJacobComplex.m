function df =NumJacobComplex(f,x0, conjug, real)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Original NumJacob by Youngmok Yun, UT Austin. (May 2013)
% Modified for complex func. by Sithan Kanna, Imperial College. (Mar 2015)
% 
% conjug  = Calcuate R-gradient or R*-gradient (CR Calculus) 
% real    = switch between real and complex-valued Jacobians 
% 
% Example Use: 
% {
% 
%    h=@(x)[x(1) ; conj(x(1))];       % nonlinear equation
% 
%    conjug = 0;   
%    real = 0; 
%    x_test = [0.5*1j]; 
%    H = NumJacobComplex(h, x_test, conjug, real) ;
% }
%
% Reference: "The Complex Gradient Operator and the CR-Calculus" 
%              by Ken Kreutz Delgado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = x0(:);             
epsilon = 1e-6;         % delta
l_x0=length(x0);        % length of x0;
f0=feval(f,x0);         % caclulate f0
l_f=size(f0,1);         % check the size of f
df = zeros(l_f,l_x0);  % allocate memory



for i=1:l_x0
    dx = [ zeros(i-1,1); epsilon; zeros(l_x0-i,1)];
    dy = [ zeros(i-1,1); epsilon; zeros(l_x0-i,1)];
    if real
       df(:,i) = ( feval(f,x0+dx) - f0)./epsilon ;
    else
        df(:,i) = (feval(f,x0+dx) - f0)./epsilon  - ((-1)^conjug)*1j*( feval(f,x0+(1j*dy)) - f0)./epsilon;
        df(:,i) = 0.5*df(:,i); 
    end
end
    