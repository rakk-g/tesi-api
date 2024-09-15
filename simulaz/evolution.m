## -*- texinfo -*-
## Evolve a solution for an ODE
##
## Damped pendulum with different values of damping

1;
pbaspect([1 1 1]) % aspect ratio
xmin=-2*pi; xmax=2*pi;
ymin=-pi; ymax=pi;

hold off
newplot
hold on
# axis ([xmin xmax ymin ymax])

for n=1:5
    gamma= 2^(-n);
    df = @(t,y) [ y(2); -y(1) - gamma*y(2)  ]; % damped harmonic
    x0=0;
    y0=1;
    [t,y] = ode45(df, [0:0.2:60], [x0, y0]);

    xlabel("t [s]");
    ylabel("position [m]");
    title("Damped pendulum")
    X=t;
    Y=y(:,1);
    legendstr=["gamma = " num2str(gamma)];
    optstr=[";" legendstr ";"];
    plot(X,Y,optstr);
    print("evolution.png");

endfor

% TEST I'm saving ONLY THE LAST simulation
% big compound matrix to save the results
    A=[t,y];
    tic;
    fid = fopen('result.txt', 'w');
    for i=1:size(A, 1)
        fprintf(fid, '%f ', A(i,:));
        fprintf(fid, '\n');
    end
    fclose(fid);
    toc
