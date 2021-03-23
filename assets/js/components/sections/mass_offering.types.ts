export type MandatoryForm = {
  contactName: string;
  contactNumber: string;
  emailAddress: string;
  fromWhom: string;
  massLanguage: string;
  offerings: OfferingForm[];
};

export type OfferingForm = {
  typeOfMass: "Special Intention" | "Thanksgiving" | "Departed Soul";
  numberOfMass: number;
  specificDates?: string;
  toWhom: string;
  intention: string;
};
