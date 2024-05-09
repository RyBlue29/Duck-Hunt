module full_adder(S, Cout, A, B, Cin);

    input A, B, Cin;
    output Cout, S;
    wire w1, w2, w3;

    and AND1(w1, A, B);
    and AND2(w2, A, Cin);
    and AND3(w3, Cin, B);

    xor Sresults(S, A, B, Cin);
    or CarryResults(Cout, w1, w2, w3);

endmodule