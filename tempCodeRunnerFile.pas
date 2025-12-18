var
    input_pin: string;
    attempts: integer;
    exit_choice: string;
begin
    randomize;//tanpa randomize, hasil random akan selalu sama setiap program dijalankan
    clrscr;
    writeln('=== PASSWORD MANAGER ===');

    write('Buat PIN pertama kali (boleh kosong): ');
    readln(input_pin);
    forever_pin := input_pin;

    attempts:=0;
    repeat
        clrscr;
        writeln('=== LOGIN ===');
        write('Masukkan PIN: ');
        readln(input_pin);

        if checkpin(input_pin) then
        begin
            attempts:= 0;
            Menu();
        end
        else
        begin
            repeat
                clrscr;
                write('PIN salah 3 kali. Mau coba lagi? (Y/N): ');
                readln(exit_choice);

                if exit_choice = '' then
                begin
                    writeln('Input tidak boleh kosong!');
                    readln;
                end
                else if (upcase(exit_choice[1]) <> 'Y') and (upcase(exit_choice[1]) <> 'N') then
                begin
                    writeln('Hanya Y atau N!');
                    readln;
                end;
            until (exit_choice <> '') and ((upcase(exit_choice[1]) = 'Y') or (upcase(exit_choice[1]) = 'N'));

    if upcase(exit_choice[1]) = 'N' then
        halt
    else
        attempts := 0;
        end;
    until false;
end.