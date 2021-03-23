export type MandatoryForm = {
  contactName: string;
  contactNumber: string;
  emailAddress: string;
  fromWhom: string;
  massLanguage: string;
  offerings: OfferingForm[];
};

export type OfferingForm =
  | SpecialIntentionForm
  | ThanksgivingForm
  | DepartedSoulForm;

export type BaseOfferingForm = {
  numberOfMass: number;
  specificDates?: string;
};

// make a wish
export type SpecialIntentionForm = BaseOfferingForm & {
  typeOfMass: "Special Intention";
  toWhom: string;
  intention: string;
};

// wish granted
export type ThanksgivingForm = BaseOfferingForm & {
  typeOfMass: "Thanksgiving";
  toWhom: string;
  intention: string;
};

// pray for souls
export type DepartedSoulForm = BaseOfferingForm & {
  typeOfMass: "Departed Soul";
  toWhom: string;
};
