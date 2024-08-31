## -*- texinfo -*-
## Draw a phase diagram.

1;
pbaspect([1 1 1]) % aspect ratio
xmin=-2*pi; xmax=2*pi;
ymin=-pi; ymax=pi;

% df = @(t,y) [y(2); (1 - y(1)^2) * y(2) - y(1)]; % Van der Pol
% df = @(t,y) [y(2); -y(1)]; % harmonic
df = @(t,y) [ y(2); -y(1)-y(2)  ]; % damped harmonic
%df = @(t,y) [sin(y(2)*pi); -cos(y(1)*pi)];

hold off
newplot
hold on
axis ([xmin xmax ymin ymax])

for n=1:500
  x0=(xmax-xmin)*rand() +xmin;
  y0=(ymax-ymin)*rand() +ymin;
  [t,y] = ode45(df, [0:0.1:1], [x0, y0]);
  X=y(:,1);
  Y=y(:,2);
  plot(X,Y)
endfor
