export type MandatoryForm = {
  contactNumber: string;
  emailAddress: string;
  fromWhom: string;
  massLanguage: string;
  offerings: OfferingForm[];
};

export type OfferingForm = {
  typeOfMass: "Special Intention" | "Thanksgiving" | "Departed Soul";
  dates?: string;
  intention?: string;
};
