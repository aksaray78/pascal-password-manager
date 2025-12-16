program PasswordManagerMontgomery;
{$mode objfpc}{$H+} //supaya compilernya paham syntax modern pascal, bukan syntax lama turbo pascal
                    //biar gak error lah
uses crt, sysutils;

const
    max = 1000;

type
    account = record
        username: string;
        password: string;
    end;

var
    forever_pin: string = '';//awal isi dari foreverpin adalah string yang kosong
    accounts: array[1..max] of account;
    count: integer = 0;//inisialisasi nilai awal count = 0

// validasi pin user di program utama
function checkpin(input_pin: string): boolean;
begin
    checkpin := (input_pin = forever_pin);
end;


// nambahin akun baru
procedure AddAccount();
var
    ref, pass: string;
begin
    clrscr;
    writeln('=== TAMBAH PASSWORD ===');

    if count >= max then
    begin
        writeln('List penuh!');
        readln;
        exit;
    end;

    repeat
        clrscr;
        writeln('=== TAMBAH PASSWORD ===');
        write('Masukkan referensi password: ');
        readln(ref);
        write('Masukkan password          : ');
        readln(pass);

        if (ref = '') or (pass = '') then
        begin
            writeln('Referensi atau password tidak boleh kosong!');
            readln;
        end;
    until (ref <> '') and (pass <> '');

    count := count + 1;
    accounts[count].username := ref;
    accounts[count].password := pass;

    writeln('Password berhasil ditambah!');
    writeln('Tekan ENTER untuk kembali!');
    readln;
end;

// ngebuat password random baru
function generatepassword(length_pass: integer): string;
const
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`~!@#$%^&*()_-+=\|[]{}:;?/><,.';
var
    i: integer;
    result_pass: string;
begin
    result_pass := '';
    for i := 1 to length_pass do
        result_pass := result_pass + chars[random(length(chars)) + 1];//length(chars) ngasih jumlah index dari chars
    generatepassword := result_pass;
end;


// ngehapus password
procedure DeleteAccount();
var
    delete, i: integer;
    delete_string: string;
begin
    clrscr;
    writeln('=== HAPUS PASSWORD ===');

    if count = 0 then
    begin
        writeln('Tidak ada password dalam list!');
        writeln('Tekan ENTER untuk kembali!');
        readln;
        exit;
    end;

    repeat
    clrscr;
    writeln('=== HAPUS PASSWORD ===');

    for i := 1 to count do
        writeln(i, '. ', accounts[i].username, ' = ', accounts[i].password);

    write('Masukkan nomor yang ingin dihapus: ');
    readln(delete_string);

    if (not TryStrToInt(delete_string,delete)) then//TryStrToInt ini mengkonversi string menjadi integer
    begin
        writeln('List tidak berupa huruf!');
        readln;
    end
    
    else if (delete < 1) or (delete > count) then
    begin
        writeln('Tidak terdapat nomor password ',delete,' dalam list!');
        readln;
    end
    until (delete >= 1) and (delete <= count) and TryStrToInt(delete_string,delete);

    for i := delete to count - 1 do
        accounts[i] := accounts[i + 1];

    count := count - 1;

    writeln('Akun berhasil dihapus!');
    writeln('Tekan ENTER untuk kembali!');
    readln;
end;


// full list semua password yang ada
procedure ShowAccounts();
var
    i: integer;
begin
    clrscr;
    writeln('=== LIST PASSWORD ===');

    if count = 0 then
    begin
        writeln('Daftar kosong!');
        writeln('Tekan ENTER untuk kembali!');
        readln;
        exit;
    end;

    for i := 1 to count do
        writeln(i, '. ', accounts[i].username, ' = ', accounts[i].password);

    writeln('Tekan ENTER untuk kembali!');
    readln;
end;


// ngubah password
procedure ChangePassword();
var
    change, i: integer;
    change_string, new_pass: string;
begin
    repeat
    clrscr;
    writeln('=== UBAH PASSWORD ===');

    if count = 0 then
    begin
        writeln('Tidak ada akun!');
        readln;
        exit;
    end;

    for i := 1 to count do
        writeln(i, '. ', accounts[i].username);

    write('Pilih nomor akun: ');
    readln(change_string);
    
    if change_string = '' then
    begin
        writeln('Tidak boleh kosong!');
        readln;
    end
    
    else if (not TryStrToInt(change_string,change)) then//TryStrToInt ini mengkonversi string menjadi integer
    begin
        writeln('List tidak berupa huruf!');
        readln;
    end

    else if (change < 1) or (change > count) then
    begin
        writeln('Tidak terdapat nomor password ',change,' dalam list!');
        readln;
    end
    until (change >= 1) and (change <= count) and TryStrToInt(change_string,change) and (change_string <> '');

    repeat
        write('Masukkan password baru: ');
        readln(new_pass);

        if new_pass = '' then
            writeln('Password tidak boleh kosong!');
    until new_pass <> '';

    accounts[change].password := new_pass;

    writeln('Password berhasil diubah!');
    writeln('Tekan ENTER untuk kembali!');
    readln;
end;


// nyari referensi password user
procedure SearchReference();
var
    keyword: string;
    i: integer;
    found: boolean;
begin
    repeat
    clrscr;
    writeln('=== CARI REFERENSI ===');
    write('Masukkan kata kunci: ');
    readln(keyword);
    if (keyword = '') then
    begin
        writeln('Tidak boleh kosong!');
        readln;
        clrscr;
    end;
    until keyword <> '';
    found := false;

    for i := 1 to count do
    begin//pos itu untuk mencari posisi atau index sebuah substring dalam string
        if pos(lowercase(keyword), lowercase(accounts[i].username)) > 0 then 
        begin
            writeln(i, '. ', accounts[i].username, ' = ', accounts[i].password);
            found := true;
        end;
    end;
    
    if not found then
        writeln('Tidak ada referensi yang cocok!');
    writeln('Tekan ENTER untuk kembali!');
    readln;
end;


// menu utama
procedure Menu();
var
    input_string, choice: string;
    pass_length: integer;
begin
    repeat
        clrscr;
        writeln('======= MENU =======');
        writeln('1. Tambah password');
        writeln('2. Generator password');
        writeln('3. Hapus password');
        writeln('4. Lihat semua password');
        writeln('5. Ubah password');
        writeln('6. Cari referensi');
        writeln('7. Keluar');
        write('Pilih: ');
        readln(choice);

        case choice of
            '1': AddAccount();
            '2': begin
                   clrscr;
                   
                   repeat
                       write('Panjang password (tanpa tanda kutip tunggal dan ganda): ');
                       readln(input_string);
                       
                       if (input_string = '') then
                       begin
                            writeln('Tidak boleh kosong!');
                            readln;
                            clrscr;
                       end
                       
                       else if (not TryStrToInt(input_string,pass_length)) then//TryStrToInt ini mengkonversi string menjadi integer
                       begin
                            writeln('Hanya menerima angka!');
                            readln;
                            clrscr;
                       end
                        
                       else if pass_length < 0 then
                       begin
                            writeln('Hanya menerima angka positif!');
                            readln;
                            clrscr;
                       end
                   until (input_string <> '') and TryStrToInt(input_string,pass_length) and (pass_length > 0);
                    
                   writeln('Password: ', generatepassword(pass_length));
                   writeln('Mohon disalin password baru Anda!');
                   writeln('Tekan ENTER untuk kembali!');
                   readln;
                 end;
            '3': DeleteAccount();
            '4': ShowAccounts();
            '5': ChangePassword();
            '6': SearchReference();
            '' : begin
                 writeln('Pilihlah antara 1 sampai 7!');
                 readln;
                 end;
        else if choice = '7' then
        exit
        else
            begin
                writeln('Hanya terdapat 7 pilihan!');
                readln;
                clrscr;
            end;
        end;
    until choice = '7';
end;



// program utama
var
    input_pin: string;
begin
    randomize;//tanpa randomize, hasil random akan selalu sama setiap program dijalankan
    clrscr;
    writeln('=== PASSWORD MANAGER ===');

    write('Buat PIN pertama kali (boleh kosong): ');
    readln(input_pin);
    forever_pin := input_pin;

    repeat
        clrscr;
        writeln('=== LOGIN ===');
        write('Masukkan PIN: ');
        readln(input_pin);

        if checkpin(input_pin) then
            Menu()
        else
        begin
            writeln('PIN salah!');
            readln;
        end;
    until false;
end.