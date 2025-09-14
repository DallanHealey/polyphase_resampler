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

data = [1, 2, 3, 4, 5, 6]
taps = [3, 4, 3]
up = 3
down = 2

assert(len(taps) % up == 0)

sci_samples = sig.upfirdn(taps, data, 3, 2)
print(sci_samples)

upsamples = []
current_sample_list = [0]*1
print(len(current_sample_list))
k = 0
for i in range(0, len(data)):
    current_sample_list = [data[i]] + current_sample_list[0:len(current_sample_list)-1]
    for j in range(0, len(taps), up):
        print(current_sample_list, taps[j:j+up])
        dot = np.multiply(current_sample_list, taps[j:j+up])
        
        for d in dot:
            print(k, d)
            if (k < down-1):
                upsamples.append(d)
                k += 1
            elif (k == down-1):
                k = 0
        
        print(upsamples)

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
