import numpy as np
import scipy.signal as sig
import matplotlib.pyplot as plt
from functools import reduce

# Found on StackOverflow: https://stackoverflow.com/questions/6800193/what-is-the-most-efficient-way-of-finding-all-the-factors-of-a-number-in-python/
def factors(n):
    return set(reduce(
        list.__add__,
        ([i, n//i] for i in range(1, int(n**0.5) + 1) if n % i == 0)))

# iq_file = open("test_file.iq", "r")
# samples_i = []
# samples_q = []
# for line in iq_file:
#     l = line.strip().split(" ")
#     for s in l:
#         samples_i.append(int.from_bytes(bytes.fromhex(s[0:4]), signed=True, byteorder="big"))
#         samples_q.append(int.from_bytes(bytes.fromhex(s[4: ]), signed=True, byteorder="big"))
# samples_i = np.array(samples_i).astype(np.int16)
# samples_q = np.array(samples_q).astype(np.int16)
# samples_iq = samples_i + samples_q*1j

# print(samples_iq)

data = [np.random.randint(-2**16, 2**16)]*np.random.randint(low=1, high=10)
num_taps = np.random.randint(1, 10)
taps = sig.firwin(num_taps, 20, fs=80).astype(np.int32)
fact = list(factors(len(taps)))
up = fact[np.random.randint(0, len(fact))]
down = np.random.randint(1, 10)
num_taps_col = int(len(taps) / up)

assert len(taps) % up == 0, "Taps aren't a multiple of the up conversion rate"

upsamples = []
current_sample_list = [0]*num_taps_col
k = 0
for i in range(0, len(data)+num_taps_col-1):
    current_phase = [0]*up
    if i >= len(data):
        current_sample_list = [0] + current_sample_list[0:len(current_sample_list)-1]
    else:    
        current_sample_list = [data[i]] + current_sample_list[0:len(current_sample_list)-1]
    # print(current_sample_list)
    for m in range(0, up):
        for j in range(0, num_taps_col):
            current_phase[m] += current_sample_list[j]*taps[j*up+m]
        # print(m, current_phase[m])
        if (k == 0 or down == 1):
            # print("Adding", current_phase[m])
            upsamples.append(current_phase[m])
            k += 1
        elif (k == down-1):
            k = 0
        else:
            k += 1

sci_samples = sig.upfirdn(taps, data, up, down)
# print("Scipy samples:", sci_samples)
# print("My samples:", upsamples)

if ((sci_samples == upsamples).all()):
    print("Correct")
else:
    print("Incorrect")
    print("Taps:", taps)
    print("Data:", data)
    print(num_taps)
    print(up, down, num_taps_col)
    print("Scipy samples:", sci_samples)
    print("My samples:", upsamples)

# fig, [time, fft] = plt.subplots(2, 1)
# time.plot(samples_iq)
# time.set_title("Time")
# fft.plot(np.fft.fftshift(np.fft.fft(samples_iq)))
# fft.set_title("FFT")
# plt.show()
