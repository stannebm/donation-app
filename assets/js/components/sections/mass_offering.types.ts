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
  typeOfMass: "Special Intention" | "Thanksgiving" | "Departed Soul";
  numberOfMass: number;
  remark: string;
};

// make a wish
export type SpecialIntentionForm = BaseOfferingForm & {
  toWhom: string;
  intention: string;
};

// wish granted
export type ThanksgivingForm = BaseOfferingForm & {
  thanksgivingTo: string;
};

// pray for souls
export type DepartedSoulForm = BaseOfferingForm & {
  nameOfDepartedSoul: string;
};
