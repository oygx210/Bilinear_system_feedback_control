function [ C_vec ] = coeffs_2D(P, Psi)
%COEFFS_2D 
%~~~~~~~~~~Extract coefficients of Polynomial term corresponding to 
% given 2D monomial basis.
%   Input: P - - - - - - The polynomial term to be expanded
%          Monom - - - - The monomials in 2 variables by natural ordering
%   Output:
%          Cxy - - - - - The coefficient row vector of polynomial in the 
%   given monomial basis space
N = length(Psi);
n = 2;
x = sym('x',[n,1]);
C_vec = zeros(1,N);
[Cxy,Txy] = coeffs(P,x,'All');
if ~isempty(Cxy)
    Cxy = reshape(Cxy,1,[]);
    Txy = reshape(Txy,1,[]);
    for i = 1:length(Txy)
        C_vec(Psi==Txy(i)) = Cxy(i);
    end
end

end

