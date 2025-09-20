import numpy as np
import scipy.signal as sig
import matplotlib.pyplot as plt

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

data = [1, 2, 3, 4]
taps = [3, 2, 2]
up = 3
down = 2
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
print("Scipy samples:", sci_samples)
print("My samples:", upsamples)

if ((sci_samples == upsamples).all()):
    print("Correct")
else:
    print("Incorrect")

# fig, [time, fft] = plt.subplots(2, 1)
# time.plot(samples_iq)
# time.set_title("Time")
# fft.plot(np.fft.fftshift(np.fft.fft(samples_iq)))
# fft.set_title("FFT")
# plt.show()
