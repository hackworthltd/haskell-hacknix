{ system
  , compiler
  , flags
  , pkgs
  , hsPkgs
  , pkgconfPkgs
  , errorHandler
  , config
  , ... }:
  ({
    flags = { release = false; };
    package = {
      specVersion = "1.12";
      identifier = { name = "purescript"; version = "0.13.8"; };
      license = "BSD-3-Clause";
      copyright = "(c) 2013-17 Phil Freeman, (c) 2014-19 Gary Burgess, (c) other contributors (see CONTRIBUTORS.md)";
      maintainer = "Gary Burgess <gary.burgess@gmail.com>, Hardy Jones <jones3.hardy@gmail.com>, Harry Garrood <harry@garrood.me>, Christoph Hegemann <christoph.hegemann1337@gmail.com>, Liam Goodacre <goodacre.liam@gmail.com>, Nathan Faubion <nathan@n-son.com>";
      author = "Phil Freeman <paf31@cantab.net>";
      homepage = "http://www.purescript.org/";
      url = "";
      synopsis = "PureScript Programming Language Compiler";
      description = "A small strongly, statically typed programming language with expressive types, inspired by Haskell and compiling to JavaScript.";
      buildType = "Simple";
      isLocal = true;
      detailLevel = "FullDetails";
      licenseFiles = [ "LICENSE" ];
      dataDir = "";
      dataFiles = [];
      extraSrcFiles = [
        "app/static/index.html"
        "app/static/index.js"
        "app/static/normalize.css"
        "app/static/pursuit.css"
        "app/static/pursuit.less"
        "bundle/build.sh"
        "bundle/README"
        "tests/purs/bundle/3551/ModuleWithDeadCode.js"
        "tests/purs/bundle/3727.js"
        "tests/purs/bundle/ObjectShorthand.js"
        "tests/purs/failing/MissingFFIImplementations.js"
        "tests/purs/passing/2172.js"
        "tests/purs/passing/EffFn.js"
        "tests/purs/passing/FunWithFunDeps.js"
        "tests/purs/passing/PolyLabels.js"
        "tests/purs/passing/RowUnion.js"
        "tests/purs/warning/UnnecessaryFFIModule.js"
        "tests/purs/warning/UnusedFFIImplementations.js"
        "tests/purs/bundle/3551.purs"
        "tests/purs/bundle/3551/ModuleWithDeadCode.purs"
        "tests/purs/bundle/3727.purs"
        "tests/purs/bundle/ObjectShorthand.purs"
        "tests/purs/bundle/PSasConstructor.purs"
        "tests/purs/docs/bower_components/purescript-newtype/src/Data/Newtype.purs"
        "tests/purs/docs/bower_components/purescript-prelude/src/Prelude.purs"
        "tests/purs/docs/src/Ado.purs"
        "tests/purs/docs/src/ChildDeclOrder.purs"
        "tests/purs/docs/src/Clash.purs"
        "tests/purs/docs/src/Clash1.purs"
        "tests/purs/docs/src/Clash1a.purs"
        "tests/purs/docs/src/Clash2.purs"
        "tests/purs/docs/src/Clash2a.purs"
        "tests/purs/docs/src/ConstrainedArgument.purs"
        "tests/purs/docs/src/DeclOrder.purs"
        "tests/purs/docs/src/DeclOrderNoExportList.purs"
        "tests/purs/docs/src/Desugar.purs"
        "tests/purs/docs/src/DocComments.purs"
        "tests/purs/docs/src/DocCommentsClassMethod.purs"
        "tests/purs/docs/src/DocCommentsDataConstructor.purs"
        "tests/purs/docs/src/DuplicateNames.purs"
        "tests/purs/docs/src/Example.purs"
        "tests/purs/docs/src/Example2.purs"
        "tests/purs/docs/src/ExplicitExport.purs"
        "tests/purs/docs/src/ExplicitTypeSignatures.purs"
        "tests/purs/docs/src/ImportedTwice.purs"
        "tests/purs/docs/src/ImportedTwiceA.purs"
        "tests/purs/docs/src/ImportedTwiceB.purs"
        "tests/purs/docs/src/MultiVirtual.purs"
        "tests/purs/docs/src/MultiVirtual1.purs"
        "tests/purs/docs/src/MultiVirtual2.purs"
        "tests/purs/docs/src/MultiVirtual3.purs"
        "tests/purs/docs/src/NewOperators.purs"
        "tests/purs/docs/src/NewOperators2.purs"
        "tests/purs/docs/src/NotAllCtors.purs"
        "tests/purs/docs/src/PrimSubmodules.purs"
        "tests/purs/docs/src/ReExportedTypeClass.purs"
        "tests/purs/docs/src/SolitaryTypeClassMember.purs"
        "tests/purs/docs/src/SomeTypeClass.purs"
        "tests/purs/docs/src/Transitive1.purs"
        "tests/purs/docs/src/Transitive2.purs"
        "tests/purs/docs/src/Transitive3.purs"
        "tests/purs/docs/src/TypeClassWithFunDeps.purs"
        "tests/purs/docs/src/TypeClassWithoutMembers.purs"
        "tests/purs/docs/src/TypeClassWithoutMembersIntermediate.purs"
        "tests/purs/docs/src/TypeLevelString.purs"
        "tests/purs/docs/src/TypeOpAliases.purs"
        "tests/purs/docs/src/TypeSynonym.purs"
        "tests/purs/docs/src/TypeSynonymInstance.purs"
        "tests/purs/docs/src/UTF8.purs"
        "tests/purs/docs/src/Virtual.purs"
        "tests/purs/failing/1071.purs"
        "tests/purs/failing/1169.purs"
        "tests/purs/failing/1175.purs"
        "tests/purs/failing/1310.purs"
        "tests/purs/failing/1570.purs"
        "tests/purs/failing/1733.purs"
        "tests/purs/failing/1733/Thingy.purs"
        "tests/purs/failing/1825.purs"
        "tests/purs/failing/1881.purs"
        "tests/purs/failing/2128-class.purs"
        "tests/purs/failing/2128-instance.purs"
        "tests/purs/failing/2197-shouldFail.purs"
        "tests/purs/failing/2197-shouldFail2.purs"
        "tests/purs/failing/2378.purs"
        "tests/purs/failing/2378/Lib.purs"
        "tests/purs/failing/2379.purs"
        "tests/purs/failing/2379/Lib.purs"
        "tests/purs/failing/2434.purs"
        "tests/purs/failing/2534.purs"
        "tests/purs/failing/2542.purs"
        "tests/purs/failing/2567.purs"
        "tests/purs/failing/2601.purs"
        "tests/purs/failing/2616.purs"
        "tests/purs/failing/2806.purs"
        "tests/purs/failing/2874-forall.purs"
        "tests/purs/failing/2874-forall2.purs"
        "tests/purs/failing/2874-wildcard.purs"
        "tests/purs/failing/2947.purs"
        "tests/purs/failing/3132.purs"
        "tests/purs/failing/3275-BindingGroupErrorPos.purs"
        "tests/purs/failing/3275-DataBindingGroupErrorPos.purs"
        "tests/purs/failing/3335-TypeOpAssociativityError.purs"
        "tests/purs/failing/3405.purs"
        "tests/purs/failing/3549-a.purs"
        "tests/purs/failing/3549.purs"
        "tests/purs/failing/365.purs"
        "tests/purs/failing/3689.purs"
        "tests/purs/failing/438.purs"
        "tests/purs/failing/881.purs"
        "tests/purs/failing/AnonArgument1.purs"
        "tests/purs/failing/AnonArgument2.purs"
        "tests/purs/failing/AnonArgument3.purs"
        "tests/purs/failing/ApostropheModuleName.purs"
        "tests/purs/failing/ArgLengthMismatch.purs"
        "tests/purs/failing/Arrays.purs"
        "tests/purs/failing/ArrayType.purs"
        "tests/purs/failing/AtPatternPrecedence.purs"
        "tests/purs/failing/BindInDo-2.purs"
        "tests/purs/failing/BindInDo.purs"
        "tests/purs/failing/CannotDeriveNewtypeForData.purs"
        "tests/purs/failing/CaseBinderLengthsDiffer.purs"
        "tests/purs/failing/CaseDoesNotMatchAllConstructorArgs.purs"
        "tests/purs/failing/ConflictingExports.purs"
        "tests/purs/failing/ConflictingExports/A.purs"
        "tests/purs/failing/ConflictingExports/B.purs"
        "tests/purs/failing/ConflictingImports.purs"
        "tests/purs/failing/ConflictingImports/A.purs"
        "tests/purs/failing/ConflictingImports/B.purs"
        "tests/purs/failing/ConflictingImports2.purs"
        "tests/purs/failing/ConflictingImports2/A.purs"
        "tests/purs/failing/ConflictingImports2/B.purs"
        "tests/purs/failing/ConflictingQualifiedImports.purs"
        "tests/purs/failing/ConflictingQualifiedImports/A.purs"
        "tests/purs/failing/ConflictingQualifiedImports/B.purs"
        "tests/purs/failing/ConflictingQualifiedImports2.purs"
        "tests/purs/failing/ConflictingQualifiedImports2/A.purs"
        "tests/purs/failing/ConflictingQualifiedImports2/B.purs"
        "tests/purs/failing/ConstraintFailure.purs"
        "tests/purs/failing/ConstraintInference.purs"
        "tests/purs/failing/DctorOperatorAliasExport.purs"
        "tests/purs/failing/DeclConflictClassCtor.purs"
        "tests/purs/failing/DeclConflictClassSynonym.purs"
        "tests/purs/failing/DeclConflictClassType.purs"
        "tests/purs/failing/DeclConflictCtorClass.purs"
        "tests/purs/failing/DeclConflictCtorCtor.purs"
        "tests/purs/failing/DeclConflictDuplicateCtor.purs"
        "tests/purs/failing/DeclConflictSynonymClass.purs"
        "tests/purs/failing/DeclConflictSynonymType.purs"
        "tests/purs/failing/DeclConflictTypeClass.purs"
        "tests/purs/failing/DeclConflictTypeSynonym.purs"
        "tests/purs/failing/DeclConflictTypeType.purs"
        "tests/purs/failing/DiffKindsSameName.purs"
        "tests/purs/failing/DiffKindsSameName/LibA.purs"
        "tests/purs/failing/DiffKindsSameName/LibB.purs"
        "tests/purs/failing/Do.purs"
        "tests/purs/failing/DoNotSuggestComposition.purs"
        "tests/purs/failing/DoNotSuggestComposition2.purs"
        "tests/purs/failing/DuplicateDeclarationsInLet.purs"
        "tests/purs/failing/DuplicateInstance.purs"
        "tests/purs/failing/DuplicateModule.purs"
        "tests/purs/failing/DuplicateModule/M1.purs"
        "tests/purs/failing/DuplicateProperties.purs"
        "tests/purs/failing/DuplicateTypeClass.purs"
        "tests/purs/failing/DuplicateTypeVars.purs"
        "tests/purs/failing/EmptyCase.purs"
        "tests/purs/failing/EmptyClass.purs"
        "tests/purs/failing/EmptyDo.purs"
        "tests/purs/failing/ExpectedWildcard.purs"
        "tests/purs/failing/ExportConflictClass.purs"
        "tests/purs/failing/ExportConflictClass/A.purs"
        "tests/purs/failing/ExportConflictClass/B.purs"
        "tests/purs/failing/ExportConflictClassAndType.purs"
        "tests/purs/failing/ExportConflictClassAndType/A.purs"
        "tests/purs/failing/ExportConflictClassAndType/B.purs"
        "tests/purs/failing/ExportConflictCtor.purs"
        "tests/purs/failing/ExportConflictCtor/A.purs"
        "tests/purs/failing/ExportConflictCtor/B.purs"
        "tests/purs/failing/ExportConflictType.purs"
        "tests/purs/failing/ExportConflictType/A.purs"
        "tests/purs/failing/ExportConflictType/B.purs"
        "tests/purs/failing/ExportConflictTypeOp.purs"
        "tests/purs/failing/ExportConflictTypeOp/A.purs"
        "tests/purs/failing/ExportConflictTypeOp/B.purs"
        "tests/purs/failing/ExportConflictValue.purs"
        "tests/purs/failing/ExportConflictValue/A.purs"
        "tests/purs/failing/ExportConflictValue/B.purs"
        "tests/purs/failing/ExportConflictValueOp.purs"
        "tests/purs/failing/ExportConflictValueOp/A.purs"
        "tests/purs/failing/ExportConflictValueOp/B.purs"
        "tests/purs/failing/ExportExplicit.purs"
        "tests/purs/failing/ExportExplicit1.purs"
        "tests/purs/failing/ExportExplicit1/M1.purs"
        "tests/purs/failing/ExportExplicit2.purs"
        "tests/purs/failing/ExportExplicit3.purs"
        "tests/purs/failing/ExportExplicit3/M1.purs"
        "tests/purs/failing/ExtraneousClassMember.purs"
        "tests/purs/failing/ExtraRecordField.purs"
        "tests/purs/failing/Foldable.purs"
        "tests/purs/failing/Generalization1.purs"
        "tests/purs/failing/Generalization2.purs"
        "tests/purs/failing/ImportExplicit.purs"
        "tests/purs/failing/ImportExplicit/M1.purs"
        "tests/purs/failing/ImportExplicit2.purs"
        "tests/purs/failing/ImportExplicit2/M1.purs"
        "tests/purs/failing/ImportHidingModule.purs"
        "tests/purs/failing/ImportHidingModule/A.purs"
        "tests/purs/failing/ImportHidingModule/B.purs"
        "tests/purs/failing/ImportModule.purs"
        "tests/purs/failing/ImportModule/M2.purs"
        "tests/purs/failing/InfiniteKind.purs"
        "tests/purs/failing/InfiniteKind2.purs"
        "tests/purs/failing/InfiniteType.purs"
        "tests/purs/failing/InstanceChainBothUnknownAndMatch.purs"
        "tests/purs/failing/InstanceChainSkolemUnknownMatch.purs"
        "tests/purs/failing/InstanceExport.purs"
        "tests/purs/failing/InstanceExport/InstanceExport.purs"
        "tests/purs/failing/InstanceSigsBodyIncorrect.purs"
        "tests/purs/failing/InstanceSigsDifferentTypes.purs"
        "tests/purs/failing/InstanceSigsIncorrectType.purs"
        "tests/purs/failing/InstanceSigsOrphanTypeDeclaration.purs"
        "tests/purs/failing/IntOutOfRange.purs"
        "tests/purs/failing/InvalidDerivedInstance.purs"
        "tests/purs/failing/InvalidDerivedInstance2.purs"
        "tests/purs/failing/InvalidOperatorInBinder.purs"
        "tests/purs/failing/KindError.purs"
        "tests/purs/failing/KindStar.purs"
        "tests/purs/failing/LacksWithSubGoal.purs"
        "tests/purs/failing/LeadingZeros1.purs"
        "tests/purs/failing/LeadingZeros2.purs"
        "tests/purs/failing/Let.purs"
        "tests/purs/failing/LetPatterns1.purs"
        "tests/purs/failing/LetPatterns2.purs"
        "tests/purs/failing/LetPatterns3.purs"
        "tests/purs/failing/LetPatterns4.purs"
        "tests/purs/failing/MissingClassExport.purs"
        "tests/purs/failing/MissingClassMember.purs"
        "tests/purs/failing/MissingClassMemberExport.purs"
        "tests/purs/failing/MissingFFIImplementations.purs"
        "tests/purs/failing/MissingRecordField.purs"
        "tests/purs/failing/MixedAssociativityError.purs"
        "tests/purs/failing/MPTCs.purs"
        "tests/purs/failing/MultipleErrors.purs"
        "tests/purs/failing/MultipleErrors2.purs"
        "tests/purs/failing/MultipleTypeOpFixities.purs"
        "tests/purs/failing/MultipleValueOpFixities.purs"
        "tests/purs/failing/MutRec.purs"
        "tests/purs/failing/MutRec2.purs"
        "tests/purs/failing/NewtypeInstance.purs"
        "tests/purs/failing/NewtypeInstance2.purs"
        "tests/purs/failing/NewtypeInstance3.purs"
        "tests/purs/failing/NewtypeInstance4.purs"
        "tests/purs/failing/NewtypeInstance5.purs"
        "tests/purs/failing/NewtypeInstance6.purs"
        "tests/purs/failing/NewtypeMultiArgs.purs"
        "tests/purs/failing/NewtypeMultiCtor.purs"
        "tests/purs/failing/NonAssociativeError.purs"
        "tests/purs/failing/NonExhaustivePatGuard.purs"
        "tests/purs/failing/NullaryAbs.purs"
        "tests/purs/failing/Object.purs"
        "tests/purs/failing/OperatorAliasNoExport.purs"
        "tests/purs/failing/OperatorAt.purs"
        "tests/purs/failing/OperatorBackslash.purs"
        "tests/purs/failing/OperatorSections.purs"
        "tests/purs/failing/OrphanInstance.purs"
        "tests/purs/failing/OrphanInstance/Class.purs"
        "tests/purs/failing/OrphanInstanceFunDepCycle.purs"
        "tests/purs/failing/OrphanInstanceFunDepCycle/Lib.purs"
        "tests/purs/failing/OrphanInstanceNullary.purs"
        "tests/purs/failing/OrphanInstanceNullary/Lib.purs"
        "tests/purs/failing/OrphanInstanceWithDetermined.purs"
        "tests/purs/failing/OrphanInstanceWithDetermined/Lib.purs"
        "tests/purs/failing/OrphanTypeDecl.purs"
        "tests/purs/failing/OverlapAcrossModules.purs"
        "tests/purs/failing/OverlapAcrossModules/Class.purs"
        "tests/purs/failing/OverlapAcrossModules/X.purs"
        "tests/purs/failing/OverlappingArguments.purs"
        "tests/purs/failing/OverlappingBinders.purs"
        "tests/purs/failing/OverlappingInstances.purs"
        "tests/purs/failing/OverlappingVars.purs"
        "tests/purs/failing/PrimModuleReserved.purs"
        "tests/purs/failing/PrimModuleReserved/Prim.purs"
        "tests/purs/failing/PrimRow.purs"
        "tests/purs/failing/PrimSubModuleReserved.purs"
        "tests/purs/failing/PrimSubModuleReserved/Prim_Foobar.purs"
        "tests/purs/failing/ProgrammableTypeErrors.purs"
        "tests/purs/failing/ProgrammableTypeErrorsTypeString.purs"
        "tests/purs/failing/Rank2Types.purs"
        "tests/purs/failing/RequiredHiddenType.purs"
        "tests/purs/failing/Reserved.purs"
        "tests/purs/failing/RowConstructors1.purs"
        "tests/purs/failing/RowConstructors2.purs"
        "tests/purs/failing/RowConstructors3.purs"
        "tests/purs/failing/RowInInstanceNotDetermined0.purs"
        "tests/purs/failing/RowInInstanceNotDetermined1.purs"
        "tests/purs/failing/RowInInstanceNotDetermined2.purs"
        "tests/purs/failing/RowLacks.purs"
        "tests/purs/failing/SelfImport.purs"
        "tests/purs/failing/SelfImport/Dummy.purs"
        "tests/purs/failing/SkolemEscape.purs"
        "tests/purs/failing/SkolemEscape2.purs"
        "tests/purs/failing/SuggestComposition.purs"
        "tests/purs/failing/Superclasses1.purs"
        "tests/purs/failing/Superclasses2.purs"
        "tests/purs/failing/Superclasses3.purs"
        "tests/purs/failing/Superclasses5.purs"
        "tests/purs/failing/TooFewClassInstanceArgs.purs"
        "tests/purs/failing/TopLevelCaseNoArgs.purs"
        "tests/purs/failing/TransitiveDctorExport.purs"
        "tests/purs/failing/TransitiveKindExport.purs"
        "tests/purs/failing/TransitiveSynonymExport.purs"
        "tests/purs/failing/TypeClasses2.purs"
        "tests/purs/failing/TypedBinders.purs"
        "tests/purs/failing/TypedBinders2.purs"
        "tests/purs/failing/TypedBinders3.purs"
        "tests/purs/failing/TypedHole.purs"
        "tests/purs/failing/TypedHole2.purs"
        "tests/purs/failing/TypeError.purs"
        "tests/purs/failing/TypeOperatorAliasNoExport.purs"
        "tests/purs/failing/TypeSynonyms.purs"
        "tests/purs/failing/TypeSynonyms2.purs"
        "tests/purs/failing/TypeSynonyms3.purs"
        "tests/purs/failing/TypeSynonyms4.purs"
        "tests/purs/failing/TypeSynonyms5.purs"
        "tests/purs/failing/TypeWildcards1.purs"
        "tests/purs/failing/TypeWildcards2.purs"
        "tests/purs/failing/TypeWildcards3.purs"
        "tests/purs/failing/UnderscoreModuleName.purs"
        "tests/purs/failing/UnknownType.purs"
        "tests/purs/failing/UnusableTypeClassMethod.purs"
        "tests/purs/failing/UnusableTypeClassMethodConflictingIdent.purs"
        "tests/purs/failing/UnusableTypeClassMethodSynonym.purs"
        "tests/purs/failing/Whitespace1.purs"
        "tests/purs/graph/src/Module.purs"
        "tests/purs/graph/src/Module2.purs"
        "tests/purs/graph/src/ModuleFailing.purs"
        "tests/purs/layout/AdoIn.purs"
        "tests/purs/layout/CaseGuards.purs"
        "tests/purs/layout/CaseWhere.purs"
        "tests/purs/layout/ClassHead.purs"
        "tests/purs/layout/Commas.purs"
        "tests/purs/layout/Delimiter.purs"
        "tests/purs/layout/DoLet.purs"
        "tests/purs/layout/DoOperator.purs"
        "tests/purs/layout/DoWhere.purs"
        "tests/purs/layout/IfThenElseDo.purs"
        "tests/purs/layout/InstanceChainElse.purs"
        "tests/purs/layout/LetGuards.purs"
        "tests/purs/passing/1110.purs"
        "tests/purs/passing/1185.purs"
        "tests/purs/passing/1335.purs"
        "tests/purs/passing/1570.purs"
        "tests/purs/passing/1664.purs"
        "tests/purs/passing/1697.purs"
        "tests/purs/passing/1807.purs"
        "tests/purs/passing/1881.purs"
        "tests/purs/passing/1991.purs"
        "tests/purs/passing/2018.purs"
        "tests/purs/passing/2018/A.purs"
        "tests/purs/passing/2018/B.purs"
        "tests/purs/passing/2049.purs"
        "tests/purs/passing/2136.purs"
        "tests/purs/passing/2138.purs"
        "tests/purs/passing/2138/Lib.purs"
        "tests/purs/passing/2172.purs"
        "tests/purs/passing/2197-1.purs"
        "tests/purs/passing/2197-2.purs"
        "tests/purs/passing/2252.purs"
        "tests/purs/passing/2288.purs"
        "tests/purs/passing/2378.purs"
        "tests/purs/passing/2438.purs"
        "tests/purs/passing/2609.purs"
        "tests/purs/passing/2609/Eg.purs"
        "tests/purs/passing/2616.purs"
        "tests/purs/passing/2626.purs"
        "tests/purs/passing/2663.purs"
        "tests/purs/passing/2689.purs"
        "tests/purs/passing/2756.purs"
        "tests/purs/passing/2787.purs"
        "tests/purs/passing/2795.purs"
        "tests/purs/passing/2803.purs"
        "tests/purs/passing/2806.purs"
        "tests/purs/passing/2947.purs"
        "tests/purs/passing/2958.purs"
        "tests/purs/passing/2972.purs"
        "tests/purs/passing/3114.purs"
        "tests/purs/passing/3114/VendoredVariant.purs"
        "tests/purs/passing/3125.purs"
        "tests/purs/passing/3187-UnusedNameClash.purs"
        "tests/purs/passing/3238.purs"
        "tests/purs/passing/3388.purs"
        "tests/purs/passing/3410.purs"
        "tests/purs/passing/3481.purs"
        "tests/purs/passing/3549.purs"
        "tests/purs/passing/3558-UpToDateDictsForHigherOrderFns.purs"
        "tests/purs/passing/3595.purs"
        "tests/purs/passing/652.purs"
        "tests/purs/passing/810.purs"
        "tests/purs/passing/862.purs"
        "tests/purs/passing/922.purs"
        "tests/purs/passing/Ado.purs"
        "tests/purs/passing/AppendInReverse.purs"
        "tests/purs/passing/Applicative.purs"
        "tests/purs/passing/ArrayType.purs"
        "tests/purs/passing/Auto.purs"
        "tests/purs/passing/AutoPrelude.purs"
        "tests/purs/passing/AutoPrelude2.purs"
        "tests/purs/passing/BindersInFunctions.purs"
        "tests/purs/passing/BindingGroups.purs"
        "tests/purs/passing/BlockString.purs"
        "tests/purs/passing/CaseInDo.purs"
        "tests/purs/passing/CaseInputWildcard.purs"
        "tests/purs/passing/CaseMultipleExpressions.purs"
        "tests/purs/passing/CaseStatement.purs"
        "tests/purs/passing/CheckFunction.purs"
        "tests/purs/passing/CheckSynonymBug.purs"
        "tests/purs/passing/CheckTypeClass.purs"
        "tests/purs/passing/Church.purs"
        "tests/purs/passing/ClassRefSyntax.purs"
        "tests/purs/passing/ClassRefSyntax/Lib.purs"
        "tests/purs/passing/Collatz.purs"
        "tests/purs/passing/Comparisons.purs"
        "tests/purs/passing/Conditional.purs"
        "tests/purs/passing/Console.purs"
        "tests/purs/passing/ConstraintInference.purs"
        "tests/purs/passing/ConstraintOutsideForall.purs"
        "tests/purs/passing/ConstraintParens.purs"
        "tests/purs/passing/ConstraintParsingIssue.purs"
        "tests/purs/passing/ContextSimplification.purs"
        "tests/purs/passing/DataAndType.purs"
        "tests/purs/passing/DataConsClassConsOverlapOk.purs"
        "tests/purs/passing/DctorName.purs"
        "tests/purs/passing/DctorOperatorAlias.purs"
        "tests/purs/passing/DctorOperatorAlias/List.purs"
        "tests/purs/passing/DeepArrayBinder.purs"
        "tests/purs/passing/DeepCase.purs"
        "tests/purs/passing/DeriveNewtype.purs"
        "tests/purs/passing/DeriveWithNestedSynonyms.purs"
        "tests/purs/passing/Deriving.purs"
        "tests/purs/passing/DerivingFunctor.purs"
        "tests/purs/passing/Do.purs"
        "tests/purs/passing/Dollar.purs"
        "tests/purs/passing/DuplicateProperties.purs"
        "tests/purs/passing/EffFn.purs"
        "tests/purs/passing/EmptyDataDecls.purs"
        "tests/purs/passing/EmptyDicts.purs"
        "tests/purs/passing/EmptyRow.purs"
        "tests/purs/passing/EmptyTypeClass.purs"
        "tests/purs/passing/EntailsKindedType.purs"
        "tests/purs/passing/Eq1Deriving.purs"
        "tests/purs/passing/Eq1InEqDeriving.purs"
        "tests/purs/passing/EqOrd.purs"
        "tests/purs/passing/ExplicitImportReExport.purs"
        "tests/purs/passing/ExplicitImportReExport/Bar.purs"
        "tests/purs/passing/ExplicitImportReExport/Foo.purs"
        "tests/purs/passing/ExplicitOperatorSections.purs"
        "tests/purs/passing/ExportedInstanceDeclarations.purs"
        "tests/purs/passing/ExportExplicit.purs"
        "tests/purs/passing/ExportExplicit/M1.purs"
        "tests/purs/passing/ExportExplicit2.purs"
        "tests/purs/passing/ExportExplicit2/M1.purs"
        "tests/purs/passing/ExtendedInfixOperators.purs"
        "tests/purs/passing/Fib.purs"
        "tests/purs/passing/FieldConsPuns.purs"
        "tests/purs/passing/FieldPuns.purs"
        "tests/purs/passing/FinalTagless.purs"
        "tests/purs/passing/ForeignKind.purs"
        "tests/purs/passing/ForeignKind/Lib.purs"
        "tests/purs/passing/FunctionalDependencies.purs"
        "tests/purs/passing/FunctionAndCaseGuards.purs"
        "tests/purs/passing/Functions.purs"
        "tests/purs/passing/Functions2.purs"
        "tests/purs/passing/FunctionScope.purs"
        "tests/purs/passing/FunWithFunDeps.purs"
        "tests/purs/passing/Generalization1.purs"
        "tests/purs/passing/GenericsRep.purs"
        "tests/purs/passing/Guards.purs"
        "tests/purs/passing/HasOwnProperty.purs"
        "tests/purs/passing/HoistError.purs"
        "tests/purs/passing/IfThenElseMaybe.purs"
        "tests/purs/passing/IfWildcard.purs"
        "tests/purs/passing/ImplicitEmptyImport.purs"
        "tests/purs/passing/Import.purs"
        "tests/purs/passing/Import/M1.purs"
        "tests/purs/passing/Import/M2.purs"
        "tests/purs/passing/ImportExplicit.purs"
        "tests/purs/passing/ImportExplicit/M1.purs"
        "tests/purs/passing/ImportHiding.purs"
        "tests/purs/passing/ImportQualified.purs"
        "tests/purs/passing/ImportQualified/M1.purs"
        "tests/purs/passing/InferRecFunWithConstrainedArgument.purs"
        "tests/purs/passing/InheritMultipleSuperClasses.purs"
        "tests/purs/passing/InstanceBeforeClass.purs"
        "tests/purs/passing/InstanceChain.purs"
        "tests/purs/passing/InstanceSigs.purs"
        "tests/purs/passing/InstanceSigsGeneral.purs"
        "tests/purs/passing/IntAndChar.purs"
        "tests/purs/passing/iota.purs"
        "tests/purs/passing/JSReserved.purs"
        "tests/purs/passing/KindedType.purs"
        "tests/purs/passing/LargeSumType.purs"
        "tests/purs/passing/Let.purs"
        "tests/purs/passing/Let2.purs"
        "tests/purs/passing/LetInInstance.purs"
        "tests/purs/passing/LetPattern.purs"
        "tests/purs/passing/LiberalTypeSynonyms.purs"
        "tests/purs/passing/Match.purs"
        "tests/purs/passing/Module.purs"
        "tests/purs/passing/Module/M1.purs"
        "tests/purs/passing/Module/M2.purs"
        "tests/purs/passing/ModuleDeps.purs"
        "tests/purs/passing/ModuleDeps/M1.purs"
        "tests/purs/passing/ModuleDeps/M2.purs"
        "tests/purs/passing/ModuleDeps/M3.purs"
        "tests/purs/passing/ModuleExport.purs"
        "tests/purs/passing/ModuleExport/A.purs"
        "tests/purs/passing/ModuleExportDupes.purs"
        "tests/purs/passing/ModuleExportDupes/A.purs"
        "tests/purs/passing/ModuleExportDupes/B.purs"
        "tests/purs/passing/ModuleExportDupes/C.purs"
        "tests/purs/passing/ModuleExportExcluded.purs"
        "tests/purs/passing/ModuleExportExcluded/A.purs"
        "tests/purs/passing/ModuleExportQualified.purs"
        "tests/purs/passing/ModuleExportQualified/A.purs"
        "tests/purs/passing/ModuleExportSelf.purs"
        "tests/purs/passing/ModuleExportSelf/A.purs"
        "tests/purs/passing/Monad.purs"
        "tests/purs/passing/MonadState.purs"
        "tests/purs/passing/MPTCs.purs"
        "tests/purs/passing/MultiArgFunctions.purs"
        "tests/purs/passing/MutRec.purs"
        "tests/purs/passing/MutRec2.purs"
        "tests/purs/passing/MutRec3.purs"
        "tests/purs/passing/NakedConstraint.purs"
        "tests/purs/passing/NamedPatterns.purs"
        "tests/purs/passing/NegativeBinder.purs"
        "tests/purs/passing/NegativeIntInRange.purs"
        "tests/purs/passing/Nested.purs"
        "tests/purs/passing/NestedRecordUpdate.purs"
        "tests/purs/passing/NestedRecordUpdateWildcards.purs"
        "tests/purs/passing/NestedTypeSynonyms.purs"
        "tests/purs/passing/NestedWhere.purs"
        "tests/purs/passing/NewConsClass.purs"
        "tests/purs/passing/Newtype.purs"
        "tests/purs/passing/NewtypeClass.purs"
        "tests/purs/passing/NewtypeEff.purs"
        "tests/purs/passing/NewtypeInstance.purs"
        "tests/purs/passing/NewtypeWithRecordUpdate.purs"
        "tests/purs/passing/NonConflictingExports.purs"
        "tests/purs/passing/NonConflictingExports/A.purs"
        "tests/purs/passing/NonOrphanInstanceFunDepExtra.purs"
        "tests/purs/passing/NonOrphanInstanceFunDepExtra/Lib.purs"
        "tests/purs/passing/NonOrphanInstanceMulti.purs"
        "tests/purs/passing/NonOrphanInstanceMulti/Lib.purs"
        "tests/purs/passing/NumberLiterals.purs"
        "tests/purs/passing/ObjectGetter.purs"
        "tests/purs/passing/Objects.purs"
        "tests/purs/passing/ObjectSynonym.purs"
        "tests/purs/passing/ObjectUpdate.purs"
        "tests/purs/passing/ObjectUpdate2.purs"
        "tests/purs/passing/ObjectUpdater.purs"
        "tests/purs/passing/ObjectWildcards.purs"
        "tests/purs/passing/OneConstructor.purs"
        "tests/purs/passing/OperatorAlias.purs"
        "tests/purs/passing/OperatorAliasElsewhere.purs"
        "tests/purs/passing/OperatorAliasElsewhere/Def.purs"
        "tests/purs/passing/OperatorAssociativity.purs"
        "tests/purs/passing/OperatorInlining.purs"
        "tests/purs/passing/Operators.purs"
        "tests/purs/passing/Operators/Other.purs"
        "tests/purs/passing/OperatorSections.purs"
        "tests/purs/passing/OptimizerBug.purs"
        "tests/purs/passing/OptionalQualified.purs"
        "tests/purs/passing/Ord1Deriving.purs"
        "tests/purs/passing/Ord1InOrdDeriving.purs"
        "tests/purs/passing/ParensInType.purs"
        "tests/purs/passing/ParensInTypedBinder.purs"
        "tests/purs/passing/PartialFunction.purs"
        "tests/purs/passing/PartialTCO.purs"
        "tests/purs/passing/Patterns.purs"
        "tests/purs/passing/PendingConflictingImports.purs"
        "tests/purs/passing/PendingConflictingImports/A.purs"
        "tests/purs/passing/PendingConflictingImports/B.purs"
        "tests/purs/passing/PendingConflictingImports2.purs"
        "tests/purs/passing/PendingConflictingImports2/A.purs"
        "tests/purs/passing/Person.purs"
        "tests/purs/passing/PolyLabels.purs"
        "tests/purs/passing/PrimedTypeName.purs"
        "tests/purs/passing/QualifiedAdo.purs"
        "tests/purs/passing/QualifiedAdo/IxApplicative.purs"
        "tests/purs/passing/QualifiedDo.purs"
        "tests/purs/passing/QualifiedDo/IxMonad.purs"
        "tests/purs/passing/QualifiedNames.purs"
        "tests/purs/passing/QualifiedNames/Either.purs"
        "tests/purs/passing/QualifiedQualifiedImports.purs"
        "tests/purs/passing/Rank2Data.purs"
        "tests/purs/passing/Rank2Object.purs"
        "tests/purs/passing/Rank2Types.purs"
        "tests/purs/passing/Rank2TypeSynonym.purs"
        "tests/purs/passing/RebindableSyntax.purs"
        "tests/purs/passing/Recursion.purs"
        "tests/purs/passing/RedefinedFixity.purs"
        "tests/purs/passing/RedefinedFixity/M1.purs"
        "tests/purs/passing/RedefinedFixity/M2.purs"
        "tests/purs/passing/RedefinedFixity/M3.purs"
        "tests/purs/passing/ReExportQualified.purs"
        "tests/purs/passing/ReExportQualified/A.purs"
        "tests/purs/passing/ReExportQualified/B.purs"
        "tests/purs/passing/ReExportQualified/C.purs"
        "tests/purs/passing/ReservedWords.purs"
        "tests/purs/passing/ResolvableScopeConflict.purs"
        "tests/purs/passing/ResolvableScopeConflict/A.purs"
        "tests/purs/passing/ResolvableScopeConflict/B.purs"
        "tests/purs/passing/ResolvableScopeConflict2.purs"
        "tests/purs/passing/ResolvableScopeConflict2/A.purs"
        "tests/purs/passing/ResolvableScopeConflict3.purs"
        "tests/purs/passing/ResolvableScopeConflict3/A.purs"
        "tests/purs/passing/RowConstructors.purs"
        "tests/purs/passing/RowInInstanceHeadDetermined.purs"
        "tests/purs/passing/RowLacks.purs"
        "tests/purs/passing/RowNub.purs"
        "tests/purs/passing/RowPolyInstanceContext.purs"
        "tests/purs/passing/RowsInInstanceContext.purs"
        "tests/purs/passing/RowUnion.purs"
        "tests/purs/passing/RunFnInline.purs"
        "tests/purs/passing/RuntimeScopeIssue.purs"
        "tests/purs/passing/s.purs"
        "tests/purs/passing/ScopedTypeVariables.purs"
        "tests/purs/passing/Sequence.purs"
        "tests/purs/passing/SequenceDesugared.purs"
        "tests/purs/passing/ShadowedModuleName.purs"
        "tests/purs/passing/ShadowedModuleName/Test.purs"
        "tests/purs/passing/ShadowedName.purs"
        "tests/purs/passing/ShadowedRename.purs"
        "tests/purs/passing/ShadowedTCO.purs"
        "tests/purs/passing/ShadowedTCOLet.purs"
        "tests/purs/passing/SignedNumericLiterals.purs"
        "tests/purs/passing/SolvingAppendSymbol.purs"
        "tests/purs/passing/SolvingCompareSymbol.purs"
        "tests/purs/passing/SolvingIsSymbol.purs"
        "tests/purs/passing/SolvingIsSymbol/Lib.purs"
        "tests/purs/passing/Stream.purs"
        "tests/purs/passing/StringEdgeCases.purs"
        "tests/purs/passing/StringEdgeCases/Records.purs"
        "tests/purs/passing/StringEdgeCases/Symbols.purs"
        "tests/purs/passing/StringEscapes.purs"
        "tests/purs/passing/Superclasses1.purs"
        "tests/purs/passing/Superclasses3.purs"
        "tests/purs/passing/TailCall.purs"
        "tests/purs/passing/TCO.purs"
        "tests/purs/passing/TCOCase.purs"
        "tests/purs/passing/Tick.purs"
        "tests/purs/passing/TopLevelCase.purs"
        "tests/purs/passing/TransitiveImport.purs"
        "tests/purs/passing/TransitiveImport/Middle.purs"
        "tests/purs/passing/TransitiveImport/Test.purs"
        "tests/purs/passing/TypeAnnotationPrecedence.purs"
        "tests/purs/passing/TypeClasses.purs"
        "tests/purs/passing/TypeClassesInOrder.purs"
        "tests/purs/passing/TypeClassesWithOverlappingTypeVariables.purs"
        "tests/purs/passing/TypeClassMemberOrderChange.purs"
        "tests/purs/passing/TypedBinders.purs"
        "tests/purs/passing/TypeDecl.purs"
        "tests/purs/passing/TypedWhere.purs"
        "tests/purs/passing/TypeOperators.purs"
        "tests/purs/passing/TypeOperators/A.purs"
        "tests/purs/passing/TypeSynonymInData.purs"
        "tests/purs/passing/TypeSynonyms.purs"
        "tests/purs/passing/TypeWildcards.purs"
        "tests/purs/passing/TypeWildcardsRecordExtension.purs"
        "tests/purs/passing/TypeWithoutParens.purs"
        "tests/purs/passing/TypeWithoutParens/Lib.purs"
        "tests/purs/passing/UnderscoreIdent.purs"
        "tests/purs/passing/UnicodeIdentifier.purs"
        "tests/purs/passing/UnicodeOperators.purs"
        "tests/purs/passing/UnicodeType.purs"
        "tests/purs/passing/UnifyInTypeInstanceLookup.purs"
        "tests/purs/passing/Unit.purs"
        "tests/purs/passing/UnknownInTypeClassLookup.purs"
        "tests/purs/passing/UnsafeCoerce.purs"
        "tests/purs/passing/UntupledConstraints.purs"
        "tests/purs/passing/UsableTypeClassMethods.purs"
        "tests/purs/passing/UTF8Sourcefile.purs"
        "tests/purs/passing/Where.purs"
        "tests/purs/passing/WildcardInInstance.purs"
        "tests/purs/passing/WildcardType.purs"
        "tests/purs/psci/BasicEval.purs"
        "tests/purs/psci/Multiline.purs"
        "tests/purs/publish/basic-example/src/Main.purs"
        "tests/purs/warning/2140.purs"
        "tests/purs/warning/2383.purs"
        "tests/purs/warning/2411.purs"
        "tests/purs/warning/2542.purs"
        "tests/purs/warning/CustomWarning.purs"
        "tests/purs/warning/CustomWarning2.purs"
        "tests/purs/warning/CustomWarning3.purs"
        "tests/purs/warning/CustomWarning4.purs"
        "tests/purs/warning/DuplicateExportRef.purs"
        "tests/purs/warning/DuplicateImport.purs"
        "tests/purs/warning/DuplicateImportRef.purs"
        "tests/purs/warning/DuplicateSelectiveImport.purs"
        "tests/purs/warning/HidingImport.purs"
        "tests/purs/warning/ImplicitImport.purs"
        "tests/purs/warning/ImplicitQualifiedImport.purs"
        "tests/purs/warning/ImplicitQualifiedImportReExport.purs"
        "tests/purs/warning/Kind-UnusedExplicitImport-1.purs"
        "tests/purs/warning/Kind-UnusedExplicitImport-2.purs"
        "tests/purs/warning/Kind-UnusedImport.purs"
        "tests/purs/warning/KindReExport.purs"
        "tests/purs/warning/MissingTypeDeclaration.purs"
        "tests/purs/warning/NewtypeInstance.purs"
        "tests/purs/warning/NewtypeInstance2.purs"
        "tests/purs/warning/NewtypeInstance3.purs"
        "tests/purs/warning/NewtypeInstance4.purs"
        "tests/purs/warning/OverlappingPattern.purs"
        "tests/purs/warning/ScopeShadowing.purs"
        "tests/purs/warning/ScopeShadowing2.purs"
        "tests/purs/warning/ShadowedBinderPatternGuard.purs"
        "tests/purs/warning/ShadowedNameParens.purs"
        "tests/purs/warning/ShadowedTypeVar.purs"
        "tests/purs/warning/UnnecessaryFFIModule.purs"
        "tests/purs/warning/UnusedDctorExplicitImport.purs"
        "tests/purs/warning/UnusedDctorImportAll.purs"
        "tests/purs/warning/UnusedDctorImportExplicit.purs"
        "tests/purs/warning/UnusedExplicitImport.purs"
        "tests/purs/warning/UnusedExplicitImportTypeOp.purs"
        "tests/purs/warning/UnusedExplicitImportTypeOp/Lib.purs"
        "tests/purs/warning/UnusedExplicitImportValOp.purs"
        "tests/purs/warning/UnusedFFIImplementations.purs"
        "tests/purs/warning/UnusedImport.purs"
        "tests/purs/warning/UnusedTypeVar.purs"
        "tests/purs/warning/WildcardInferredType.purs"
        "tests/purs/warning/WildcardInferredType2.purs"
        "tests/purs/docs/bower.json"
        "tests/purs/docs/resolutions.json"
        "tests/purs/graph/graph.json"
        "tests/purs/publish/basic-example/bower.json"
        "tests/purs/publish/basic-example/resolutions-legacy.json"
        "tests/purs/publish/basic-example/resolutions.json"
        "tests/json-compat/v0.11.3/generics-4.0.0.json"
        "tests/json-compat/v0.11.3/symbols-3.0.0.json"
        "tests/json-compat/v0.12.1/typelevel-prelude-3.0.0.json"
        "tests/support/bower.json"
        "tests/support/package.json"
        "tests/support/prelude-resolutions.json"
        "tests/support/setup-win.cmd"
        "tests/support/psci/InteractivePrint.purs"
        "tests/support/psci/Reload.purs"
        "tests/support/psci/Reload.edit"
        "tests/support/pscide/src/CompletionSpecDocs.purs"
        "tests/support/pscide/src/FindUsage.purs"
        "tests/support/pscide/src/FindUsage/Definition.purs"
        "tests/support/pscide/src/FindUsage/Recursive.purs"
        "tests/support/pscide/src/FindUsage/RecursiveShadowed.purs"
        "tests/support/pscide/src/FindUsage/Reexport.purs"
        "tests/support/pscide/src/ImportsSpec.purs"
        "tests/support/pscide/src/ImportsSpec1.purs"
        "tests/support/pscide/src/MatcherSpec.purs"
        "tests/support/pscide/src/RebuildSpecDep.purs"
        "tests/support/pscide/src/RebuildSpecSingleModule.purs"
        "tests/support/pscide/src/RebuildSpecWithDeps.purs"
        "tests/support/pscide/src/RebuildSpecWithForeign.purs"
        "tests/support/pscide/src/RebuildSpecWithHiddenIdent.purs"
        "tests/support/pscide/src/RebuildSpecWithForeign.js"
        "tests/support/pscide/src/RebuildSpecSingleModule.fail"
        "tests/support/pscide/src/RebuildSpecWithMissingForeign.fail"
        "stack.yaml"
        "README.md"
        "INSTALL.md"
        "CONTRIBUTORS.md"
        "CONTRIBUTING.md"
        ];
      extraTmpFiles = [];
      extraDocFiles = [];
      };
    components = {
      "library" = {
        depends = [
          (hsPkgs."Cabal" or (errorHandler.buildDepError "Cabal"))
          (hsPkgs."Glob" or (errorHandler.buildDepError "Glob"))
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."aeson-better-errors" or (errorHandler.buildDepError "aeson-better-errors"))
          (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
          (hsPkgs."ansi-terminal" or (errorHandler.buildDepError "ansi-terminal"))
          (hsPkgs."array" or (errorHandler.buildDepError "array"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base-compat" or (errorHandler.buildDepError "base-compat"))
          (hsPkgs."blaze-html" or (errorHandler.buildDepError "blaze-html"))
          (hsPkgs."bower-json" or (errorHandler.buildDepError "bower-json"))
          (hsPkgs."boxes" or (errorHandler.buildDepError "boxes"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."cborg" or (errorHandler.buildDepError "cborg"))
          (hsPkgs."cheapskate" or (errorHandler.buildDepError "cheapskate"))
          (hsPkgs."clock" or (errorHandler.buildDepError "clock"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
          (hsPkgs."data-ordlist" or (errorHandler.buildDepError "data-ordlist"))
          (hsPkgs."deepseq" or (errorHandler.buildDepError "deepseq"))
          (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
          (hsPkgs."dlist" or (errorHandler.buildDepError "dlist"))
          (hsPkgs."edit-distance" or (errorHandler.buildDepError "edit-distance"))
          (hsPkgs."file-embed" or (errorHandler.buildDepError "file-embed"))
          (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
          (hsPkgs."fsnotify" or (errorHandler.buildDepError "fsnotify"))
          (hsPkgs."haskeline" or (errorHandler.buildDepError "haskeline"))
          (hsPkgs."language-javascript" or (errorHandler.buildDepError "language-javascript"))
          (hsPkgs."lifted-async" or (errorHandler.buildDepError "lifted-async"))
          (hsPkgs."lifted-base" or (errorHandler.buildDepError "lifted-base"))
          (hsPkgs."memory" or (errorHandler.buildDepError "memory"))
          (hsPkgs."microlens-platform" or (errorHandler.buildDepError "microlens-platform"))
          (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
          (hsPkgs."monad-logger" or (errorHandler.buildDepError "monad-logger"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."parallel" or (errorHandler.buildDepError "parallel"))
          (hsPkgs."parsec" or (errorHandler.buildDepError "parsec"))
          (hsPkgs."pattern-arrows" or (errorHandler.buildDepError "pattern-arrows"))
          (hsPkgs."process" or (errorHandler.buildDepError "process"))
          (hsPkgs."protolude" or (errorHandler.buildDepError "protolude"))
          (hsPkgs."regex-tdfa" or (errorHandler.buildDepError "regex-tdfa"))
          (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
          (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
          (hsPkgs."semialign" or (errorHandler.buildDepError "semialign"))
          (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
          (hsPkgs."serialise" or (errorHandler.buildDepError "serialise"))
          (hsPkgs."sourcemap" or (errorHandler.buildDepError "sourcemap"))
          (hsPkgs."split" or (errorHandler.buildDepError "split"))
          (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
          (hsPkgs."stringsearch" or (errorHandler.buildDepError "stringsearch"))
          (hsPkgs."syb" or (errorHandler.buildDepError "syb"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."these" or (errorHandler.buildDepError "these"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."transformers-base" or (errorHandler.buildDepError "transformers-base"))
          (hsPkgs."transformers-compat" or (errorHandler.buildDepError "transformers-compat"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
          (hsPkgs."utf8-string" or (errorHandler.buildDepError "utf8-string"))
          (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
          ];
        build-tools = [
          (hsPkgs.buildPackages.happy or (pkgs.buildPackages.happy or (errorHandler.buildToolDepError "happy")))
          ];
        buildable = true;
        modules = [
          "Paths_purescript"
          "Control/Monad/Logger"
          "Control/Monad/Supply"
          "Control/Monad/Supply/Class"
          "Language/PureScript"
          "Language/PureScript/AST"
          "Language/PureScript/AST/Binders"
          "Language/PureScript/AST/Declarations"
          "Language/PureScript/AST/Exported"
          "Language/PureScript/AST/Literals"
          "Language/PureScript/AST/Operators"
          "Language/PureScript/AST/SourcePos"
          "Language/PureScript/AST/Traversals"
          "Language/PureScript/Bundle"
          "Language/PureScript/CodeGen"
          "Language/PureScript/CodeGen/JS"
          "Language/PureScript/CodeGen/JS/Common"
          "Language/PureScript/CodeGen/JS/Printer"
          "Language/PureScript/Comments"
          "Language/PureScript/Constants"
          "Language/PureScript/CoreFn"
          "Language/PureScript/CoreFn/Ann"
          "Language/PureScript/CoreFn/Binders"
          "Language/PureScript/CoreFn/Desugar"
          "Language/PureScript/CoreFn/Expr"
          "Language/PureScript/CoreFn/FromJSON"
          "Language/PureScript/CoreFn/Meta"
          "Language/PureScript/CoreFn/Module"
          "Language/PureScript/CoreFn/Optimizer"
          "Language/PureScript/CoreFn/ToJSON"
          "Language/PureScript/CoreFn/Traversals"
          "Language/PureScript/CoreImp"
          "Language/PureScript/CoreImp/AST"
          "Language/PureScript/CoreImp/Optimizer"
          "Language/PureScript/CoreImp/Optimizer/Blocks"
          "Language/PureScript/CoreImp/Optimizer/Common"
          "Language/PureScript/CoreImp/Optimizer/Inliner"
          "Language/PureScript/CoreImp/Optimizer/MagicDo"
          "Language/PureScript/CoreImp/Optimizer/TCO"
          "Language/PureScript/CoreImp/Optimizer/Unused"
          "Language/PureScript/Crash"
          "Language/PureScript/CST"
          "Language/PureScript/CST/Convert"
          "Language/PureScript/CST/Errors"
          "Language/PureScript/CST/Layout"
          "Language/PureScript/CST/Lexer"
          "Language/PureScript/CST/Monad"
          "Language/PureScript/CST/Parser"
          "Language/PureScript/CST/Positions"
          "Language/PureScript/CST/Print"
          "Language/PureScript/CST/Traversals"
          "Language/PureScript/CST/Traversals/Type"
          "Language/PureScript/CST/Types"
          "Language/PureScript/CST/Utils"
          "Language/PureScript/Docs"
          "Language/PureScript/Docs/AsHtml"
          "Language/PureScript/Docs/AsMarkdown"
          "Language/PureScript/Docs/Collect"
          "Language/PureScript/Docs/Convert"
          "Language/PureScript/Docs/Convert/ReExports"
          "Language/PureScript/Docs/Convert/Single"
          "Language/PureScript/Docs/Css"
          "Language/PureScript/Docs/Prim"
          "Language/PureScript/Docs/Render"
          "Language/PureScript/Docs/RenderedCode"
          "Language/PureScript/Docs/RenderedCode/RenderKind"
          "Language/PureScript/Docs/RenderedCode/RenderType"
          "Language/PureScript/Docs/RenderedCode/Types"
          "Language/PureScript/Docs/Tags"
          "Language/PureScript/Docs/Types"
          "Language/PureScript/Docs/Utils/MonoidExtras"
          "Language/PureScript/Environment"
          "Language/PureScript/Errors"
          "Language/PureScript/Errors/JSON"
          "Language/PureScript/Externs"
          "Language/PureScript/Graph"
          "Language/PureScript/Hierarchy"
          "Language/PureScript/Ide"
          "Language/PureScript/Ide/CaseSplit"
          "Language/PureScript/Ide/Command"
          "Language/PureScript/Ide/Completion"
          "Language/PureScript/Ide/Error"
          "Language/PureScript/Ide/Externs"
          "Language/PureScript/Ide/Filter"
          "Language/PureScript/Ide/Filter/Declaration"
          "Language/PureScript/Ide/Imports"
          "Language/PureScript/Ide/Logging"
          "Language/PureScript/Ide/Matcher"
          "Language/PureScript/Ide/Prim"
          "Language/PureScript/Ide/Rebuild"
          "Language/PureScript/Ide/Reexports"
          "Language/PureScript/Ide/SourceFile"
          "Language/PureScript/Ide/State"
          "Language/PureScript/Ide/Types"
          "Language/PureScript/Ide/Usage"
          "Language/PureScript/Ide/Util"
          "Language/PureScript/Interactive"
          "Language/PureScript/Interactive/Completion"
          "Language/PureScript/Interactive/Directive"
          "Language/PureScript/Interactive/IO"
          "Language/PureScript/Interactive/Message"
          "Language/PureScript/Interactive/Module"
          "Language/PureScript/Interactive/Parser"
          "Language/PureScript/Interactive/Printer"
          "Language/PureScript/Interactive/Types"
          "Language/PureScript/Kinds"
          "Language/PureScript/Label"
          "Language/PureScript/Linter"
          "Language/PureScript/Linter/Exhaustive"
          "Language/PureScript/Linter/Imports"
          "Language/PureScript/Make"
          "Language/PureScript/Make/Actions"
          "Language/PureScript/Make/BuildPlan"
          "Language/PureScript/Make/Cache"
          "Language/PureScript/Make/Monad"
          "Language/PureScript/ModuleDependencies"
          "Language/PureScript/Names"
          "Language/PureScript/Options"
          "Language/PureScript/Pretty"
          "Language/PureScript/Pretty/Common"
          "Language/PureScript/Pretty/Kinds"
          "Language/PureScript/Pretty/Types"
          "Language/PureScript/Pretty/Values"
          "Language/PureScript/PSString"
          "Language/PureScript/Publish"
          "Language/PureScript/Publish/BoxesHelpers"
          "Language/PureScript/Publish/ErrorsWarnings"
          "Language/PureScript/Publish/Utils"
          "Language/PureScript/Renamer"
          "Language/PureScript/Sugar"
          "Language/PureScript/Sugar/AdoNotation"
          "Language/PureScript/Sugar/BindingGroups"
          "Language/PureScript/Sugar/CaseDeclarations"
          "Language/PureScript/Sugar/DoNotation"
          "Language/PureScript/Sugar/LetPattern"
          "Language/PureScript/Sugar/Names"
          "Language/PureScript/Sugar/Names/Common"
          "Language/PureScript/Sugar/Names/Env"
          "Language/PureScript/Sugar/Names/Exports"
          "Language/PureScript/Sugar/Names/Imports"
          "Language/PureScript/Sugar/ObjectWildcards"
          "Language/PureScript/Sugar/Operators"
          "Language/PureScript/Sugar/Operators/Binders"
          "Language/PureScript/Sugar/Operators/Common"
          "Language/PureScript/Sugar/Operators/Expr"
          "Language/PureScript/Sugar/Operators/Types"
          "Language/PureScript/Sugar/TypeClasses"
          "Language/PureScript/Sugar/TypeClasses/Deriving"
          "Language/PureScript/Sugar/TypeDeclarations"
          "Language/PureScript/Traversals"
          "Language/PureScript/TypeChecker"
          "Language/PureScript/TypeChecker/Entailment"
          "Language/PureScript/TypeChecker/Kinds"
          "Language/PureScript/TypeChecker/Monad"
          "Language/PureScript/TypeChecker/Skolems"
          "Language/PureScript/TypeChecker/Subsumption"
          "Language/PureScript/TypeChecker/Synonyms"
          "Language/PureScript/TypeChecker/Types"
          "Language/PureScript/TypeChecker/TypeSearch"
          "Language/PureScript/TypeChecker/Unify"
          "Language/PureScript/TypeClassDictionaries"
          "Language/PureScript/Types"
          "System/IO/UTF8"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "purs" = {
          depends = [
            (hsPkgs."Cabal" or (errorHandler.buildDepError "Cabal"))
            (hsPkgs."Glob" or (errorHandler.buildDepError "Glob"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-better-errors" or (errorHandler.buildDepError "aeson-better-errors"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."ansi-terminal" or (errorHandler.buildDepError "ansi-terminal"))
            (hsPkgs."ansi-wl-pprint" or (errorHandler.buildDepError "ansi-wl-pprint"))
            (hsPkgs."array" or (errorHandler.buildDepError "array"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base-compat" or (errorHandler.buildDepError "base-compat"))
            (hsPkgs."blaze-html" or (errorHandler.buildDepError "blaze-html"))
            (hsPkgs."bower-json" or (errorHandler.buildDepError "bower-json"))
            (hsPkgs."boxes" or (errorHandler.buildDepError "boxes"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."cborg" or (errorHandler.buildDepError "cborg"))
            (hsPkgs."cheapskate" or (errorHandler.buildDepError "cheapskate"))
            (hsPkgs."clock" or (errorHandler.buildDepError "clock"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."data-ordlist" or (errorHandler.buildDepError "data-ordlist"))
            (hsPkgs."deepseq" or (errorHandler.buildDepError "deepseq"))
            (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
            (hsPkgs."dlist" or (errorHandler.buildDepError "dlist"))
            (hsPkgs."edit-distance" or (errorHandler.buildDepError "edit-distance"))
            (hsPkgs."file-embed" or (errorHandler.buildDepError "file-embed"))
            (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
            (hsPkgs."fsnotify" or (errorHandler.buildDepError "fsnotify"))
            (hsPkgs."haskeline" or (errorHandler.buildDepError "haskeline"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."language-javascript" or (errorHandler.buildDepError "language-javascript"))
            (hsPkgs."lifted-async" or (errorHandler.buildDepError "lifted-async"))
            (hsPkgs."lifted-base" or (errorHandler.buildDepError "lifted-base"))
            (hsPkgs."memory" or (errorHandler.buildDepError "memory"))
            (hsPkgs."microlens-platform" or (errorHandler.buildDepError "microlens-platform"))
            (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
            (hsPkgs."monad-logger" or (errorHandler.buildDepError "monad-logger"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network" or (errorHandler.buildDepError "network"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."parallel" or (errorHandler.buildDepError "parallel"))
            (hsPkgs."parsec" or (errorHandler.buildDepError "parsec"))
            (hsPkgs."pattern-arrows" or (errorHandler.buildDepError "pattern-arrows"))
            (hsPkgs."process" or (errorHandler.buildDepError "process"))
            (hsPkgs."protolude" or (errorHandler.buildDepError "protolude"))
            (hsPkgs."purescript" or (errorHandler.buildDepError "purescript"))
            (hsPkgs."regex-tdfa" or (errorHandler.buildDepError "regex-tdfa"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."semialign" or (errorHandler.buildDepError "semialign"))
            (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
            (hsPkgs."serialise" or (errorHandler.buildDepError "serialise"))
            (hsPkgs."sourcemap" or (errorHandler.buildDepError "sourcemap"))
            (hsPkgs."split" or (errorHandler.buildDepError "split"))
            (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
            (hsPkgs."stringsearch" or (errorHandler.buildDepError "stringsearch"))
            (hsPkgs."syb" or (errorHandler.buildDepError "syb"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."these" or (errorHandler.buildDepError "these"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."transformers-base" or (errorHandler.buildDepError "transformers-base"))
            (hsPkgs."transformers-compat" or (errorHandler.buildDepError "transformers-compat"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."utf8-string" or (errorHandler.buildDepError "utf8-string"))
            (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-websockets" or (errorHandler.buildDepError "wai-websockets"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."websockets" or (errorHandler.buildDepError "websockets"))
            ] ++ (pkgs.lib).optional (!flags.release) (hsPkgs."gitrev" or (errorHandler.buildDepError "gitrev"));
          build-tools = [
            (hsPkgs.buildPackages.happy or (pkgs.buildPackages.happy or (errorHandler.buildToolDepError "happy")))
            ];
          buildable = true;
          modules = [
            "Command/Bundle"
            "Command/Compile"
            "Command/Docs"
            "Command/Docs/Html"
            "Command/Docs/Markdown"
            "Command/Graph"
            "Command/Hierarchy"
            "Command/Ide"
            "Command/Publish"
            "Command/REPL"
            "Paths_purescript"
            "Version"
            ];
          hsSourceDirs = [ "app" ];
          mainPath = [ "Main.hs" ] ++ [ "" ];
          };
        };
      tests = {
        "tests" = {
          depends = [
            (hsPkgs."Cabal" or (errorHandler.buildDepError "Cabal"))
            (hsPkgs."Glob" or (errorHandler.buildDepError "Glob"))
            (hsPkgs."HUnit" or (errorHandler.buildDepError "HUnit"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-better-errors" or (errorHandler.buildDepError "aeson-better-errors"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."ansi-terminal" or (errorHandler.buildDepError "ansi-terminal"))
            (hsPkgs."array" or (errorHandler.buildDepError "array"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base-compat" or (errorHandler.buildDepError "base-compat"))
            (hsPkgs."blaze-html" or (errorHandler.buildDepError "blaze-html"))
            (hsPkgs."bower-json" or (errorHandler.buildDepError "bower-json"))
            (hsPkgs."boxes" or (errorHandler.buildDepError "boxes"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."cborg" or (errorHandler.buildDepError "cborg"))
            (hsPkgs."cheapskate" or (errorHandler.buildDepError "cheapskate"))
            (hsPkgs."clock" or (errorHandler.buildDepError "clock"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."data-ordlist" or (errorHandler.buildDepError "data-ordlist"))
            (hsPkgs."deepseq" or (errorHandler.buildDepError "deepseq"))
            (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
            (hsPkgs."dlist" or (errorHandler.buildDepError "dlist"))
            (hsPkgs."edit-distance" or (errorHandler.buildDepError "edit-distance"))
            (hsPkgs."file-embed" or (errorHandler.buildDepError "file-embed"))
            (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
            (hsPkgs."fsnotify" or (errorHandler.buildDepError "fsnotify"))
            (hsPkgs."haskeline" or (errorHandler.buildDepError "haskeline"))
            (hsPkgs."hspec" or (errorHandler.buildDepError "hspec"))
            (hsPkgs."hspec-discover" or (errorHandler.buildDepError "hspec-discover"))
            (hsPkgs."language-javascript" or (errorHandler.buildDepError "language-javascript"))
            (hsPkgs."lifted-async" or (errorHandler.buildDepError "lifted-async"))
            (hsPkgs."lifted-base" or (errorHandler.buildDepError "lifted-base"))
            (hsPkgs."memory" or (errorHandler.buildDepError "memory"))
            (hsPkgs."microlens-platform" or (errorHandler.buildDepError "microlens-platform"))
            (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
            (hsPkgs."monad-logger" or (errorHandler.buildDepError "monad-logger"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."parallel" or (errorHandler.buildDepError "parallel"))
            (hsPkgs."parsec" or (errorHandler.buildDepError "parsec"))
            (hsPkgs."pattern-arrows" or (errorHandler.buildDepError "pattern-arrows"))
            (hsPkgs."process" or (errorHandler.buildDepError "process"))
            (hsPkgs."protolude" or (errorHandler.buildDepError "protolude"))
            (hsPkgs."purescript" or (errorHandler.buildDepError "purescript"))
            (hsPkgs."regex-tdfa" or (errorHandler.buildDepError "regex-tdfa"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."semialign" or (errorHandler.buildDepError "semialign"))
            (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
            (hsPkgs."serialise" or (errorHandler.buildDepError "serialise"))
            (hsPkgs."sourcemap" or (errorHandler.buildDepError "sourcemap"))
            (hsPkgs."split" or (errorHandler.buildDepError "split"))
            (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
            (hsPkgs."stringsearch" or (errorHandler.buildDepError "stringsearch"))
            (hsPkgs."syb" or (errorHandler.buildDepError "syb"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-golden" or (errorHandler.buildDepError "tasty-golden"))
            (hsPkgs."tasty-hspec" or (errorHandler.buildDepError "tasty-hspec"))
            (hsPkgs."tasty-quickcheck" or (errorHandler.buildDepError "tasty-quickcheck"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."these" or (errorHandler.buildDepError "these"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."transformers-base" or (errorHandler.buildDepError "transformers-base"))
            (hsPkgs."transformers-compat" or (errorHandler.buildDepError "transformers-compat"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."utf8-string" or (errorHandler.buildDepError "utf8-string"))
            (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
            ];
          build-tools = [
            (hsPkgs.buildPackages.happy or (pkgs.buildPackages.happy or (errorHandler.buildToolDepError "happy")))
            ];
          buildable = true;
          modules = [
            "Language/PureScript/Ide/CompletionSpec"
            "Language/PureScript/Ide/FilterSpec"
            "Language/PureScript/Ide/ImportsSpec"
            "Language/PureScript/Ide/MatcherSpec"
            "Language/PureScript/Ide/RebuildSpec"
            "Language/PureScript/Ide/ReexportsSpec"
            "Language/PureScript/Ide/SourceFileSpec"
            "Language/PureScript/Ide/StateSpec"
            "Language/PureScript/Ide/Test"
            "Language/PureScript/Ide/UsageSpec"
            "PscIdeSpec"
            "TestBundle"
            "TestCompiler"
            "TestCoreFn"
            "TestCst"
            "TestDocs"
            "TestGraph"
            "TestHierarchy"
            "TestIde"
            "TestMake"
            "TestPrimDocs"
            "TestPsci"
            "TestPsci/CommandTest"
            "TestPsci/CompletionTest"
            "TestPsci/EvalTest"
            "TestPsci/TestEnv"
            "TestPscPublish"
            "TestUtils"
            "Paths_purescript"
            ];
          hsSourceDirs = [ "tests" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./.;
    }) // { cabal-generator = "hpack"; }