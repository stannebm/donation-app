export type MainForm = {
  contactName: string;
  contactNumber: string;
  emailAddress: string;
  fromWhom: string;
  massLanguage: string;
  requests: RequestForm[];
};

export type RequestForm =
  | SpecialIntentionForm
  | ThanksgivingForm
  | DepartedSoulForm;

export type BaseRequestForm = {
  typeOfMass: string; // auto infer
  numberOfMass: number;
  extraDates?: Date[];
};

// make a wish
export type SpecialIntentionForm = BaseRequestForm & {
  toWhom: string;
  intention: string;
};

// wish granted
export type ThanksgivingForm = BaseRequestForm & {
  thanksgivingTo: string;
};

// pray for souls
export type DepartedSoulForm = BaseRequestForm & {
  nameOfDepartedSoul: string;
};
