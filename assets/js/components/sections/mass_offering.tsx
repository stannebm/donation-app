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
import * as R from "ramda";
import React, { useState } from "react";
import { useFieldArray, useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";
import DatePicker from "../elements/datepicker";
import type { MandatoryForm } from "./mass_offering.types";

export default function MassOffering() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    control,
    watch,
  } = useForm<MandatoryForm>({
    defaultValues: {
      offerings: [{ typeOfMass: undefined }],
    },
  });

  const onSubmit = (data: MandatoryForm) => {
    console.log("SUBMIT:", data);
    console.log(JSON.stringify(data));
  };

  const { fields, append, remove } = useFieldArray({
    control,
    name: "offerings",
  });

  const [selectedDates, setSelectedDates] = useState<{
    [index: number]: Date[];
  }>({});
  const offerings = watch("offerings");

  const totalMasses = 1; // FIXME
  /* console.log("errors", errors);
* console.log("selectedDates", selectedDates); */

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Contact H/P"
          errors={errors}
          {...register("contactNumber", { required: true })}
        />
        <FormInput
          label="Email"
          errors={errors}
          {...register("emailAddress", {
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
          label="Offer by Whom"
          errors={errors}
          {...register("fromWhom", { required: true })}
        />
        <FormSelect
          label="Mass Language"
          options={["English", "Mandarin", "Tamil", "Bahasa"]}
          errors={errors}
          {...register("massLanguage", { required: true })}
        />
      </HStack>
      {fields.map(
        (item, index): JSX.Element => {
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
                    errorPath={R.path(["offerings", index, "typeOfMass"])}
                    defaultValue={item.typeOfMass}
                    {...register(`offerings.${index}.typeOfMass` as const, {
                      required: true,
                    })}
                  />
                </HStack>
                <VStack>
                  {offerings[index].typeOfMass === "Special Intention" && (
                    <>
                      <FormInput
                        label="Intention"
                        errors={errors}
                        errorPath={R.path(["offerings", index, "intention"])}
                        defaultValue={item.intention}
                        {...register(`offerings.${index}.intention` as const, {
                          required: true,
                        })}
                      />
                    </>
                  )}
                  {offerings[index].typeOfMass === "Thanksgiving" && (
                    <>
                      <FormInput
                        label="Intention"
                        errors={errors}
                        errorPath={R.path(["offerings", index, "intention"])}
                        defaultValue={item.intention}
                        {...register(`offerings.${index}.intention` as const, {
                          required: true,
                        })}
                      />
                    </>
                  )}
                  {offerings[index].typeOfMass === "Departed Soul" && (
                    <>
                      <FormInput
                        label="Name of Departed Soul"
                        errors={errors}
                        errorPath={R.path(["offerings", index, "intention"])}
                        defaultValue={item.intention}
                        {...register(`offerings.${index}.intention` as const, {
                          required: true,
                        })}
                      />
                    </>
                  )}
                </VStack>

                {offerings[index].typeOfMass?.length > 0 && (
                  <>
                    <Box mt={2}>
                      <Text color="gray.600" fontSize="sm">Selected dates:</Text>
                      {selectedDates[index]?.map((d: Date) => (
                        <Text fontSize="md">{d.toLocaleDateString()}</Text>
                      ))}
                    </Box>

                    <Popover>
                      <PopoverTrigger>
                        <Box mt={2}>
                          <Button
                            size="md"
                            fontWeight={400}
                            colorScheme="teal"
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
                      onClick={() => remove(index)}
                    >
                      Remove
                    </Button>
                  </Box>
                )}
              </Box>
            </>
          );
        },
      )}

      <Box my={3}>
        <Button
          size="md"
          fontWeight={400}
          colorScheme="teal"
          type="button"
          variant="link"
          leftIcon={<PlusSquareIcon />}
          onClick={() => {
            append({
              typeOfMass: undefined,
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
        <Button colorScheme="teal" isLoading={isSubmitting} type="submit">
          Transfer
        </Button>
      </HStack>
    </form>
  );
}
