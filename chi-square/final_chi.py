import tkinter as tk
from tkinter import ttk
import csv

labels_lst = [] # тут лежать розщеплення
numbers_lst = [] # тут лежать фенотипні класи
def add_ratio_and_number():

# Get the text from the "Enter Ratio" entry
    ratio_text = enter_ratio_entry.get()
    ratio_text = int(ratio_text)

    labels_lst.append(ratio_text)
    # Create a new label for the entered ratio text
    #new_label = ttk.Label(ratio_frame, text=ratio_text)


    # Add the new label and entry to the "ratio" frame
    #new_label.grid(row=ratio_frame.grid_size()[1], column=0, padx=10, pady=5, sticky="w")
#    new_entry.grid(row=ratio_frame.grid_size()[1] - 1, column=1, padx=10, pady=5)


    # Get the text from the "Enter Ratio" entry
    number_text = new_entry.get()
    number_text = int(number_text)
    numbers_lst.append(number_text)
    # Create a new label for the entered ratio text
    new_label = ttk.Label(ratio_frame, text="{}, {}".format(ratio_text,number_text))

    # Add the new label and entry to the "ratio" frame
    new_label.grid(row=ratio_frame.grid_size()[1], column=0, padx=10, pady=5, sticky="w")

    #get_chi_button["state"] = "enabled"
    enter_ratio_entry.delete(0, "end")
    new_entry.delete(0, "end")
    return labels_lst, numbers_lst

def get_chi():
    #Update the text in the result_text widget
    if chi_csv() == False:
        text = "Chi-Square does not match the theoretical value"
    else:
        text = "Chi-Square matches the theoretical value"
    result_text = f"Chi-Square : {calc_chi()}"

    chi_label = ttk.Label(result_frame, text=result_text)
    chi_label.grid(row=2, column=0, pady=10)
    chi_label = ttk.Label(result_frame, text=text)
    chi_label.grid(row=3, column=0, pady=10)


root = tk.Tk()
#app = CustomTkinterApp(root)

root.title("Chi-Square")

        # Create the "ratio" frame
ratio_frame = ttk.Frame(root)
#ratio_frame = ttk.Scrollbar(root, orient="vertical")
ratio_frame.pack(side="left", fill="y", padx=10)

        # Create the "Enter Ratio" entry, "Add Ratio" button, and label for "ratio" frame
ratio_label = ttk.Label(ratio_frame, text="Define Ratio")
enter_ratio_entry = ttk.Entry(ratio_frame, width=5)
new_entry = ttk.Entry(ratio_frame, width=5)
add_ratio_button = ttk.Button(ratio_frame, text="Add values", command=add_ratio_and_number)

ratio_l_1 = ttk.Label(ratio_frame, text="Ratio: ")
num_l_1 = ttk.Label(ratio_frame, text="Number: ")

#add_new_entry_button = ttk.Button(ratio_frame, text="Add Number", command=add_number)

ratio_label.grid(row=0, column=0, columnspan=2, pady=10)
enter_ratio_entry.grid(row=1, column=1, padx=5, pady=5)
new_entry.grid(row=2, column=1, padx=10, pady=10)
add_ratio_button.grid(row=1, column=3, padx=10, pady=10)

ratio_l_1.grid(row=1, column=0, padx=5, pady=5)
num_l_1.grid(row=2, column=0, padx=10, pady=10)

#add_new_entry_button.grid(row=2, column=1, padx=10, pady=10)

        # Create the "i" frame
i_frame = ttk.Frame(root)
i_frame.pack(side="left", fill="y", padx=10)

        # Create the label and dropdown list in the "i" frame
i_label = ttk.Label(i_frame, text="Probability level ")
i_var = tk.StringVar(value=0.95)
i_dropdown = ttk.Combobox(i_frame, textvariable=i_var, values=[0.99, 0.95, 0.8, 0.5, 0.2, 0.05, 0.01])

i_label.grid(row=0, column=0, pady=10)
i_dropdown.grid(row=0, column=1, pady=10)

        # Create the "result" frame
result_frame = ttk.Frame(root)
result_frame.pack(side="left", fill="y", padx=10)

        # Create the label, "Get Chi" button, and space for text in the "result" frame
result_label = ttk.Label(result_frame, text="Result")
get_chi_button = ttk.Button(result_frame, text="Get Chi", command=get_chi)
#result_text = tk.Text(result_frame, height=10, width=30, state="disabled")

result_label.grid(row=0, column=0, pady=10)
get_chi_button.grid(row=1, column=0, pady=10)
#result_text.grid(row=2, column=0, pady=10)

        #self.numbers_lst = []

i_num = i_dropdown.get()

def calc_chi():
    ratio = labels_lst
    ph_classes = numbers_lst
    r = sum(ph_classes) / sum(ratio)
    # chi calculation
    chi = 0  # chi declaration
    i = 0  # index tracking
    for ph_class in ph_classes:
        chi_class = ((ratio[i] * r - ph_class) ** 2) / (ratio[i] * r)
        chi += chi_class
        i += 1

    return chi

def chi_csv():
    chi = calc_chi()
    p = float(i_dropdown.get())
    i = len(labels_lst) - 1
    # with open('chi_ref.csv') as csvfile:
    #     reader = csv.DictReader(csvfile, delimiter=";")
    #     for line in reader:
    #         if int(line['0']) == i:
    #             if float(line[p]) > chi:
    #                 return True
    #             else:
    #                 return False
    with open('chi_ref.csv') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=";")
        table = []
        for line in reader:
            new_line = {}
            for key, value in line.items():
                key = key.replace(',', '.')
                value = value.replace(',', '.')
                new_line[float(key)] = float(value)
            table.append(new_line)

        for line in table:
            if int(line[0]) == i:
                if line[p] > chi:
                    return True
                    print("chi theor ", line[p])
                else:
                    return False

    csvfile.close()




root.mainloop()
print(labels_lst)
print(numbers_lst)
print(i_num)