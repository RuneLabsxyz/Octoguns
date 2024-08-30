const BASE_I64: number = 100000000;
const FAST_I90: number = 90 * BASE_I64;
const BASE: number = 100000000;
const FAST_360: number = 360 * BASE;
const FAST_180: number = 180 * BASE;
const FAST_90: number = 90 * BASE;
const FAST_10: number = 10 * BASE;

const sin_table: number[] = [
    0, // sin(0)
    17364818, // sin(10)
    34202014, // sin(20)
    50000000, // sin(30)
    64278761, // sin(40)
    76604444, // sin(50)
    86602540, // sin(60)
    93969262, // sin(70)
    98480775, // sin(80)
    100000000 // sin(90)
];

const cos_table: number[] = [
    100000000, // cos(0)
    99984769, // cos(1)
    99939082, // cos(2)
    99862953, // cos(3)
    99756405, // cos(4)
    99619470, // cos(5)
    99452190, // cos(6)
    99254615, // cos(7)
    99026807, // cos(8)
    98768834, // cos(9)
];

function fast_sin_inner(x: number): [boolean, number] {
    const hollyst: number = 1745329;
    let a = x % FAST_360;
    let sig = true;
    if (a > FAST_180) {
        sig = false;
        a = a - FAST_180;
    }
    if (a > FAST_90) {
        a = FAST_180 - a;
    }
    const i: number = Math.floor(a / FAST_10);
    const j = a - i * FAST_10;
    const int_j: number = Math.floor(j / BASE);
    const y = Math.floor((sin_table[i] * cos_table[int_j]) / BASE) +
        Math.floor((Math.floor((j * hollyst) / BASE) * sin_table[9 - i]) / BASE);
    return [sig, y];
}

function fast_sin(x: number): number {
    let a = x;
    if (x < 0) {
        a = -x;
    }
    const [sig_u64, result_u64] = fast_sin_inner(a);
    let sig = sig_u64;
    if (x < 0) {
        sig = !sig;
    }
    if (sig) {
        return result_u64;
    } else {
        return -result_u64;
    }
}

function fast_cos(x: number): number {
    let a = x + FAST_I90;
    if (x < 0) {
        a = -x;
    }
    const [sig, result_u64] = fast_sin_inner(a);
    if (sig) {
        return result_u64;
    } else {
        return -result_u64;
    }
}

function fast_tan(x: number): number {
    let a = x;
    if (x < 0) {
        a = -x;
    }
    const [sig_sin, result_u64_sin] = fast_sin_inner(a);
    const [sig_cos, result_u64_cos] = fast_sin_inner(a + FAST_I90);
    let sig = sig_sin || sig_cos;
    if (x < 0) {
        sig = !sig;
    }
    const result_u64 = Math.floor((result_u64_sin * BASE) / result_u64_cos);
    if (sig) {
        return result_u64;
    } else {
        return -result_u64;
    }
}
