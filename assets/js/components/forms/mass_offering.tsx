import { CalendarIcon, MinusIcon, PlusSquareIcon } from "@chakra-ui/icons";
import {
  Box,
  Button,
  HStack,
  Popover,
  PopoverBody,
  PopoverCloseButton,
  PopoverContent,
  PopoverTrigger,
  Text,
  VStack,
} from "@chakra-ui/react";
import axios from "axios";
import * as R from "ramda";
import React, { useState } from "react";
import { useFieldArray, useForm } from "react-hook-form";
import DatePicker from "../elements/datepicker";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";

export type MassOfferingForm = {
  reference_no: string;
  contact_number: string;
  email: string;
  name: string;
  amount: number;
  payment_method: string;
  mass_language?: string;
  intentions: IntentionForm[];
};

export type IntentionForm = {
  intention?: string;
  dates?: string[];
  type_of_mass: "Special Intention" | "Thanksgiving" | "Departed Soul";
  other_intention?: string;
};

const FORM_TYPE = "mass_offering";
const API_PATH = "/api/mass_offering_form";
const FPX_URL = "https://fpxuat.minorbasilicastannebm.com/fpx";
const CYBERSOURCE_URL =
  "https://cybersource.minorbasilicastannebm.com/cybersource";

type PaymentLinkParams = {
  paymentMethod: string;
  referenceNo: number;
  amount: number;
  name: string;
  email: string;
};

const mkPaymentUrl = ({
  paymentMethod,
  referenceNo,
  amount,
  name,
  email,
}: PaymentLinkParams) => {
  const path = paymentMethod === "fpx" ? FPX_URL : CYBERSOURCE_URL;
  return `${path}?reference_no=${referenceNo}&amount=${amount}&name=${name}&email=${email}`;
};

export default function MassOffering() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    control,
    watch,
  } = useForm<MassOfferingForm>({
    defaultValues: {
      intentions: [{ type_of_mass: undefined }],
    },
  });

  const onSubmit =
    (paymentMethod: "fpx" | "cybersource") => (data: MassOfferingForm) => {
      const submission = { ...data };
      const referenceNo = new Date().getTime();
      const amount = totalMasses * 10;
      const email = submission["email"];
      const name = submission["name"];

      submission.intentions = submission.intentions.map((o, index) => ({
        ...o,
        ...{
          dates: selectedDates[index].map((d) => d.toISOString().substr(0, 10)),
        },
      }));

      const submissionPayload = {
        [FORM_TYPE]: {
          ...submission,
          reference_no: referenceNo,
          amount: amount,
          payment_method: paymentMethod,
        },
      };
      console.log("DEBUG submission", submissionPayload);
      axios
        .post(API_PATH, submissionPayload)
        .then(function ({ data }) {
          window.location.replace(
            mkPaymentUrl({
              paymentMethod,
              referenceNo,
              amount,
              name,
              email,
            }),
          );
          console.log("posted resp:", data);
        })
        .catch(function (error) {
          console.log(error);
        });
    };

  const { fields, append, remove } = useFieldArray({
    control,
    name: "intentions",
  });

  const [selectedDates, setSelectedDates] = useState<{
    [index: number]: Date[];
  }>({});

  const intentions = watch("intentions");

  const totalMasses = Object.values(selectedDates).reduce(
    (acc, list) => acc + list.length,
    0,
  );

  return (
    <form>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Offer by Whom"
          errors={errors}
          {...register("name", { required: true })}
        />
        <FormInput
          label="Email"
          errors={errors}
          {...register("email", {
            required: true,
            pattern: {
              value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
              message: "Invalid email address",
            },
          })}
        />
      </HStack>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Contact H/P"
          errors={errors}
          {...register("contact_number", { required: true })}
        />
        <FormSelect
          label="Mass Language"
          options={["English", "Mandarin", "Tamil", "Bahasa"]}
          errors={errors}
          {...register("mass_language", { required: true })}
        />
      </HStack>
      {fields.map((item, index): JSX.Element => {
        return (
          <>
            <Box mb={5} p={3} bg="gray.100">
              <HStack mb={3} key={item.id}>
                <FormSelect
                  label="Mass Offering/Intention"
                  options={[
                    "Special Intention",
                    "Thanksgiving",
                    "Departed Soul",
                  ]}
                  bg="white"
                  errors={errors}
                  errorPath={R.path(["intentions", index, "type_of_mass"])}
                  defaultValue={item.type_of_mass}
                  {...register(`intentions.${index}.type_of_mass` as const, {
                    required: true,
                  })}
                />
              </HStack>
              <VStack>
                {intentions[index].type_of_mass === "Special Intention" && (
                  <>
                    <FormInput
                      label="Intention"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`intentions.${index}.intention` as const, {
                        required: false,
                      })}
                    />
                  </>
                )}
                {intentions[index].type_of_mass === "Thanksgiving" && (
                  <>
                    <FormInput
                      label="Intention"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`intentions.${index}.intention` as const, {
                        required: false,
                      })}
                    />
                  </>
                )}
                {intentions[index].type_of_mass === "Departed Soul" && (
                  <>
                    <FormInput
                      label="Name of Departed Soul"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`intentions.${index}.intention` as const, {
                        required: false,
                      })}
                    />
                  </>
                )}
              </VStack>

              {intentions[index].type_of_mass?.length > 0 && (
                <>
                  <Box mt={2}>
                    <Text color="gray.600" fontSize="sm">
                      Selected dates:
                    </Text>
                    {selectedDates[index]?.map((d: Date) => (
                      <Text fontSize="md">{d.toLocaleDateString()}</Text>
                    ))}
                  </Box>

                  <Popover>
                    <PopoverTrigger>
                      <Box mt={2}>
                        <Button
                          size="md"
                          fontWeight={600}
                          colorScheme="blue"
                          type="button"
                          variant="link"
                          leftIcon={<CalendarIcon />}
                        >
                          Select Dates
                        </Button>
                      </Box>
                    </PopoverTrigger>
                    <PopoverContent>
                      <PopoverCloseButton />
                      <PopoverBody>
                        <DatePicker
                          index={index}
                          selectedDays={selectedDates}
                          setSelectedDays={setSelectedDates}
                        />
                      </PopoverBody>
                    </PopoverContent>
                  </Popover>
                </>
              )}

              {index >= 1 && (
                <Box mt={2}>
                  <Button
                    size="md"
                    colorScheme="red"
                    fontWeight={400}
                    type="button"
                    variant="link"
                    leftIcon={<MinusIcon />}
                    onClick={() => {
                      remove(index);
                      setSelectedDates((prev) =>
                        Object.keys(prev)
                          .filter((key) => parseInt(key) !== index)
                          .reduce((obj: any, key) => {
                            const intkey = parseInt(key);
                            obj[intkey] = prev[intkey];
                            return obj;
                          }, {}),
                      );
                    }}
                  >
                    Remove
                  </Button>
                </Box>
              )}
            </Box>
          </>
        );
      })}

      <Box my={3} p={2}>
        <Button
          size="md"
          fontWeight={600}
          colorScheme="blue"
          type="button"
          variant="outline"
          leftIcon={<PlusSquareIcon />}
          onClick={() => {
            append({
              type_of_mass: undefined,
            });
          }}
        >
          More Offerings
        </Button>
      </Box>

      <Box mb={5}>
        <Text color="gray.500" fontWeight={500} align="left" mb={2}>
          Love offering : RM10 per Mass
        </Text>
        <Text color="gray.600" fontWeight={800} align="left" mb={-1}>
          Total:
        </Text>
        <Text fontSize="2xl" fontWeight={800} as="h3" color="gray.600">
          {`RM ${totalMasses ? totalMasses * 10 : 0}`}
        </Text>
      </Box>

      <HStack>
        {/* <Button colorScheme="teal" isLoading={isSubmitting} onClick={(e) => {
          handleSubmit(onSubmit("fpx"))()
          e.preventDefault()
        }}>
          Online Banking
        </Button> */}

        <Button
          colorScheme="teal"
          isLoading={isSubmitting}
          onClick={(e) => {
            handleSubmit(onSubmit("cybersource"))();
            e.preventDefault();
          }}
        >
          Credit/Debit Card
        </Button>
      </HStack>
    </form>
  );
}
