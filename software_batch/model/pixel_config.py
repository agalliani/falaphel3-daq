from dataclasses import dataclass

@dataclass
class PixelConfig:
    t_up_tuner: int
    tdac_tuner: int


def load_pixel_configs(path):
    matrix = [[None]*8 for _ in range(32)]  # oppure 16×16 se è 256 entry
    
    with open(path) as f:
        next(f)  # skip header
        for line in f:
            row, col, t_up, tdac = line.strip().split("\t")
            r = int(row)
            c = int(col)
            matrix[r][c] = PixelConfig(int(t_up), int(tdac))
    
    return matrix
